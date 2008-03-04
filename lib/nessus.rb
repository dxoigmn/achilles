require 'yaml'
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
          @plugin     = Nessus::Plugin.new
          @plugin.id  = attrs['id'].to_i
        end
      
      when 'results'
        @report.hosts = []
      
      when 'result'
        @host = Nessus::Host.new if @report.hosts

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
        @vulnerability = Nessus::Vulnerability.new
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
  
  class Report
    attr_accessor :plugins, :hosts
  end

  class Plugin
    attr_accessor :id, :name, :version, :family, :cve, :bugtraq, :category, :risk, :summary, :copyright
  end
  
  class Host
    attr_accessor :name, :ip, :scan_start, :scan_end, :vulnerabilities
  end

  class Vulnerability
    attr_accessor :protocol, :port, :service, :severity, :plugin_id, :data
  end

  def self.parse(xml)
    report = Nessus::Report.new
    REXML::Document.parse_stream(File.new(xml), XMLListener.new(report))
    report
  end
end