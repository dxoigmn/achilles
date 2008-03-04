class Scan < ActiveRecord::Base
  has_many :hosts
  belongs_to :location
  
  acts_as_state_machine :initial => :waiting

  state :waiting
  state :running
  state :finished
  
  event :start do
    transitions :to => :running, :from => :waiting
  end
  
  event :stop do
    transitions :to => :finished, :from => :running
  end
  
  def output!(str)
    output << str + "\n"
    save!
  end
  
  def self.process
    scan = Scan.find_in_state(:first, :waiting, :order => 'starts_at')
    
    return unless scan && Time.now >= scan.starts_at

    scan.start!
    scan.output!("Executing nessus....")
    
    # TODO: Execute nessus to output to file

    scan.output!("Parsing results....")
    
    report = Nessus.parse(File.join(RAILS_ROOT, 'data', 'results.xml'))

    scan.output!("Adding results into achilles....")
    
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
        plugin        = Plugin.find(vulnerability.plugin_id) rescue nil

        if plugin && nessus_plugin
          mismatched = []
          mismatched << "name"      if plugin.name      != nessus_plugin.name
          mismatched << "version"   if plugin.version   != nessus_plugin.version
          mismatched << "family"    if plugin.family    != nessus_plugin.family
          mismatched << "cve"       if plugin.cve       != nessus_plugin.cve
          mismatched << "bugtraq"   if plugin.bugtraq   != nessus_plugin.bugtraq
          mismatched << "category"  if plugin.category  != nessus_plugin.category
          mismatched << "risk"      if plugin.risk      != nessus_plugin.risk
          mismatched << "summary"   if plugin.summary   != nessus_plugin.summary

          # TODO: This should probably prompt the user asking for which version they would like to keep.

          scan.output!("Plugin #{plugin.id} fields are mismatched: #{mismatched.join(', ')}") if mismatched.length > 0
        elsif nessus_plugin
          plugin                        = Plugin.new
          plugin.id                     = nessus_plugin.id
          plugin.name                   = nessus_plugin.name
          plugin.version                = nessus_plugin.version
          plugin.family                 = nessus_plugin.family
          plugin.cve                    = nessus_plugin.cve
          plugin.bugtraq                = nessus_plugin.bugtraq
          plugin.category               = nessus_plugin.category
          plugin.risk                   = nessus_plugin.risk
          plugin.summary                = nessus_plugin.summary
          plugin.vulnerabilities_count  = 1
          plugin.save!
        else
          scan.output!("Please import data for plugin #{nessus_vulnerability.plugin_id}") unless plugin
        end
      end
    end

    scan.stop!
  end
end
