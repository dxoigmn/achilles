require 'resolv'
require 'netaddr'
require 'rexml/document'
require 'rexml/streamlistener'
require 'rexml/parsers/streamparser'

module Nessus
  class XMLListener
    include REXML::StreamListener
    
    def initialize(report)
      @report = report
      @text   = nil
    end
    
    def tag_start(name, attrs)
      case name
      when 'report'
        version = attrs['version']
        fail "Unsupported version: #{version}" unless version == '1.4'
        
      when 'plugins'
        @report.plugins = []
        
      when 'plugin'
        if @report.plugins
          @plugin     = NessusPlugin.new
          @plugin.id  = attrs['id'].to_i
        end
      
      when 'results'
        @report.hosts = []
      
      when 'result'
        @host = NessusHost.new if @report.hosts

      when 'host'
        if @host
          @host.name  = attrs['name']
          @host.ip    = attrs['ip']
        end
        
      when 'ports'
        @host.vulnerabilities = []
        
      when 'port'
        @last_protocol  = attrs['protocol']
        @last_port      = attrs['portid'].to_i
        
      when 'service'
        @last_service   = attrs['name']
      
      when 'information'
        @vulnerability = NessusVulnerability.new
        @vulnerability.protocol = @last_protocol
        @vulnerability.port     = @last_port
        @vulnerability.service  = @last_service
      
      end
    end

    def text(text)
      @text = text
    end

    def tag_end(name)
      case name
      # Plugin attributes
      when 'name'
        @plugin.name = @text if @plugin
        
      when 'version'
        @plugin.version = @text if @plugin
        
      when 'family'
        @plugin.family = @text if @plugin
      
      when 'cve_id'
        @plugin.cve = @text if @plugin
      
      when 'bugtraq_id'
        @plugin.bugtraq = @text if @plugin
      
      when 'category'
        @plugin.category = @text if @plugin
      
      when 'risk'
        @plugin.risk = @text if @plugin
      
      when 'summary'
        @plugin.summary = @text if @plugin
      
      when 'copyright'
        @plugin.copyright = @text if @plugin
      
      when 'plugin'
        if @plugin
          @report.plugins << @plugin
          @plugin = nil
        end
      
      # Host attributes
      when 'start'
        @host.scan_start = @text if @host
        
      when 'end'
        @host.scan_end = @text if @host
      
      when 'result'
        if @host
          @report.hosts << @host
          @host = nil
        end
      
      # Vulnerability attributes
      when 'severity'
        @vulnerability.severity = @text if @vulnerability
        
      when 'id'
        @vulnerability.plugin_id = @text.to_i if @vulnerability
        
      when 'data'
        @vulnerability.data = @text if @vulnerability
      
      when 'port'
        @last_protocol  = nil
        @last_port      = nil
        @last_service   = nil
          
      when 'information'
        @host.vulnerabilities << @vulnerability
        @vulnerability = nil

      end
      
      @text = nil
    end
  end
  
  class NessusReport
    attr_accessor :plugins, :hosts
  end

  class NessusPlugin
    attr_accessor :id, :name, :version, :family, :cve, :bugtraq, :category, :risk, :summary, :copyright

    def risk
      case @risk
      when /^critical/i;  'Critical'
      when /^high/i;      'High'
      when /^medium/i;    'Medium'
      else;               'Low'
      end
    end
  end
  
  class NessusHost
    attr_accessor :name, :ip, :scan_start, :scan_end, :vulnerabilities
    
    # TODO: Should use Plugin::HOST_FQDN to determine FQDN, example:
    # 129.170.213.82 resolves as metrosense-dev.cs.dartmouth.edu.
  end

  class NessusVulnerability
    attr_accessor :protocol, :port, :service, :severity, :plugin_id, :data
  end

  def self.process(scan, file)
    scan.output!("Parsing #{file}...")

    report = NessusReport.new
    REXML::Document.parse_stream(File.new(file), XMLListener.new(report))

    scan.output!("Importing #{file}...")

    report.hosts.each do |nessus_host|
      host            = scan.hosts.new
      host.name       = nessus_host.name
      host.ip         = Resolv.getaddress(nessus_host.ip)
      host.scan_start = DateTime.parse(nessus_host.scan_start)
      host.scan_end   = DateTime.parse(nessus_host.scan_end)
      host.save!

      nessus_host.vulnerabilities.each do |nessus_vulnerability|
        vulnerability           = host.vulnerabilities.new
        vulnerability.protocol  = nessus_vulnerability.protocol
        vulnerability.port      = nessus_vulnerability.port
        vulnerability.service   = nessus_vulnerability.service
        vulnerability.plugin_id = nessus_vulnerability.plugin_id
        vulnerability.data      = nessus_vulnerability.data.strip.split(/\n/).map { |line| line.strip }.join("\n")
        vulnerability.host_id   = host.id
        vulnerability.save!

        nessus_plugin = report.plugins.find { |plugin| plugin.id == nessus_vulnerability.plugin_id }
        plugin        = Plugin.find(vulnerability.plugin_id, :include => [:family, :risk]) rescue nil

        if plugin && nessus_plugin
          mismatched = []
          mismatched << "name"      if plugin.name        != nessus_plugin.name
          mismatched << "version"   if plugin.version     != nessus_plugin.version
          mismatched << "family"    if plugin.family.to_s != nessus_plugin.family
          mismatched << "cve"       if plugin.cve         != nessus_plugin.cve
          mismatched << "bugtraq"   if plugin.bugtraq     != nessus_plugin.bugtraq
          mismatched << "category"  if plugin.category    != nessus_plugin.category
          mismatched << "risk"      if plugin.risk.to_s   != nessus_plugin.risk
          mismatched << "summary"   if plugin.summary     != nessus_plugin.summary

          # TODO: This should probably prompt the user asking for which version they would like to keep.

          scan.output!("The following fields for plugin #{plugin.id} are mismatched: #{mismatched.join(', ')}") if mismatched.length > 0
        elsif nessus_plugin
          plugin                        = Plugin.new
          plugin.id                     = nessus_plugin.id
          plugin.name                   = nessus_plugin.name
          plugin.version                = nessus_plugin.version
          plugin.family                 = Family.find_or_create_by_name(nessus_plugin.family)
          plugin.cve                    = nessus_plugin.cve
          plugin.bugtraq                = nessus_plugin.bugtraq
          plugin.category               = nessus_plugin.category
          plugin.risk                   = Risk.find_or_create_by_name(nessus_plugin.risk)
          plugin.summary                = nessus_plugin.summary
          plugin.vulnerabilities_count  = 1
          plugin.save!
        else
          scan.output!("Please import data for plugin #{nessus_vulnerability.plugin_id}") unless plugin
        end
      end
    end
  end
end