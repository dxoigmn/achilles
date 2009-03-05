module Nessus
  class NessusReport
    attr_accessor :hosts

    def self.parse(xml)
      nessus_report       = NessusReport.new
      nessus_report.hosts = xml.find('//ReportHost').map { |report_host| NessusHost.parse(report_host) }
      nessus_report
    end
  end

  class NessusHost
    attr_accessor :name, :scan_start, :scan_end, :vulnerabilities
    
    def name
      return fqdn[1] if fqdn
      @name
    end
    
    def ip
      return fqdn[0] if fqdn
      Resolve.getaddress(name)
    rescue
      '0.0.0.0'
    end

    def self.parse(xml)
      nessus_host                 = NessusHost.new
      nessus_host.name            = xml.find_first('HostName').content rescue nil
      nessus_host.scan_start      = DateTime.parse(xml.find_first('startTime').content) rescue nil
      nessus_host.scan_end        = DateTime.parse(xml.find_first('stopTime').content) rescue nil
      nessus_host.vulnerabilities = xml.find('ReportItem').map { |report_item| NessusVulnerability.parse(report_item) }
      nessus_host
    end

    private
      def fqdn
        host_fqdn = vulnerabilities.find { |vulnerability| vulnerability.plugin_id == 12053 }

        if host_fqdn
          return host_fqdn.data.strip.scan(/(\S+) resolves as (\S+)./).flatten
        end
      
        nil
      end
  end

  class NessusVulnerability
    attr_accessor :port, :severity, :plugin_name, :plugin_id, :data
    
    def self.parse(xml)
      nessus_vulnerability              = NessusVulnerability.new
      nessus_vulnerability.port         = xml.find_first('port').content rescue nil
      nessus_vulnerability.severity     = xml.find_first('severity').content.to_i rescue nil
      nessus_vulnerability.plugin_name  = xml.find_first('pluginName').content rescue nil
      nessus_vulnerability.plugin_id    = xml.find_first('pluginID').content.to_i rescue nil
      nessus_vulnerability.data         = xml.find_first('data').content.gsub("\\n", "\n").gsub("\\r", "\r").strip rescue nil
      nessus_vulnerability
    end
  end
  
  class NessusPlugin
    attr_accessor :id, :family, :name, :category, :copyright, :summary, :version, :cve, :bid, :xref, :risk
    
    def self.parse(scan, line)
      return nil unless line =~ /\d+|[^|]+|[^|]+|[^|]+|[^|]+|[^|]+|[^|]+|[^|]+|[^|]+|.+/
      
      parts = line.split("|", 11)
      
      nessus_plugin           = NessusPlugin.new
      nessus_plugin.id        = parts.shift.to_i
      nessus_plugin.family    = parts.shift
      nessus_plugin.name      = parts.shift
      nessus_plugin.category  = parts.shift
      nessus_plugin.copyright = parts.shift
      nessus_plugin.summary   = parts.shift
      nessus_plugin.version   = parts.shift
      nessus_plugin.cve       = parts.shift
      nessus_plugin.bid       = parts.shift
      nessus_plugin.xref      = parts.shift
      nessus_plugin.risk      = case parts.shift.gsub("\\n", "\n").gsub("\\r", "\r").strip.scan(/risk factor\s*:\s*(\w+)/im).flatten.first
                                when /^critical/i;  'Critical'
                                when /^high/i;      'High'
                                when /^medium/i;    'Medium'
                                when /^low/i;       'Low'
                                when /^none/i;      'None'
                                when /^risk/i;      'Unknown'
                                when /^depends/i;   'Unknown'
                                when nil;           'Unknown'
                                else
                                  scan.puts("WARNING: Unknown risk, \"#{@risk}\"") if scan
                                  'Unknown'
                                end
      
      nessus_plugin
    end
  end
  
  def self.process(scan, nessus_file, plugins_file)
    # Parse results
    scan.puts("Parsing results in #{nessus_file}...")
    
    nessus_report = NessusReport.parse(XML::Document.file(nessus_file))
    
    # Parse plugins
    scan.puts("Parsing plugins in #{plugins_file}...")
    
    nessus_plugins = {}
    
    File.open(plugins_file).each_line do |line|
      nessus_plugin = NessusPlugin.parse(scan, line)
      
      next unless nessus_plugin
      
      nessus_plugins[nessus_plugin.id] = nessus_plugin
    end
    
    # Import results
    scan.puts("Importing #{nessus_report.hosts.size} hosts...")
    
    nessus_report.hosts.each do |nessus_host|
      scan.hosts.new do |host|
        host.name       = nessus_host.name
        host.ip         = nessus_host.ip
        host.scan_start = nessus_host.scan_start
        host.scan_end   = nessus_host.scan_end
        host.save!
        
        nessus_host.vulnerabilities.each do |nessus_vulnerability|
          host.vulnerabilities.new do |vulnerability|
            plugin = Plugin.find_by_id(nessus_vulnerability.plugin_id)
            
            unless plugin
              nessus_plugin = nessus_plugins[nessus_vulnerability.plugin_id]
              
              fail "Couldn't find plugin #{nessus_vulnerability.plugin_id} referenced by vulnerability!" unless nessus_plugin
              
              Plugin.new do |plugin|
                plugin.id       = nessus_plugin.id
                plugin.name     = nessus_plugin.name
                plugin.version  = nessus_plugin.version
                plugin.family   = Family.find_or_create_by_name(nessus_plugin.family)
                plugin.cve      = nessus_plugin.cve
                plugin.bugtraq  = nessus_plugin.bid
                plugin.category = nessus_plugin.category
                plugin.risk     = Risk.find_or_create_by_name(nessus_plugin.risk)
                plugin.summary  = nessus_plugin.summary
                plugin.save!
              end
            end
            
            vulnerability.port    = nessus_vulnerability.port
            vulnerability.data    = nessus_vulnerability.data
            vulnerability.plugin  = plugin
            vulnerability.save!
          end
        end
      end
    end
  end
  
  def self.process_plugins(scan, file)
    scan.puts("Import plugins from #{file}") if scan
    
    File.open(file).each_line do |line|
      nessus_plugin = NessusPlugin.parse(scan, line)
      
      next unless nessus_plugin

      plugin = Plugin.find_by_id(nessus_plugin.id)

      unless plugin
        Plugin.new do |plugin|
          plugin.id       = nessus_plugin.id
          plugin.name     = nessus_plugin.name
          plugin.version  = nessus_plugin.version
          plugin.family   = Family.find_or_create_by_name(nessus_plugin.family)
          plugin.cve      = nessus_plugin.cve
          plugin.bugtraq  = nessus_plugin.bid
          plugin.category = nessus_plugin.category
          plugin.risk     = Risk.find_or_create_by_name(nessus_plugin.risk)
          plugin.summary  = nessus_plugin.summary
          plugin.save!
        end
      end
    end
  end
  
  def self.process_results(scan, file)
    scan.puts("Parsing #{file}...")

    nessus_report = NessusReport.parse(XML::Document.file(file))

    scan.puts("Importing #{nessus_report.hosts.size} hosts...")

    nessus_report.hosts.each do |nessus_host|
      scan.hosts.new do |host|
        host.name       = nessus_host.name
        host.ip         = nessus_host.ip
        host.scan_start = nessus_host.scan_start
        host.scan_end   = nessus_host.scan_end
        host.save!
    
        nessus_host.vulnerabilities.each do |nessus_vulnerability|
          host.vulnerabilities.new do |vulnerability|
            vulnerability.port      = nessus_vulnerability.port
            vulnerability.data      = nessus_vulnerability.data
            vulnerability.plugin_id = nessus_vulnerability.plugin_id
            vulnerability.save!
          end
        end
      end
    end
  end
end
