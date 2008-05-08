class Scan < ActiveRecord::Base
  has_many :hosts
  has_and_belongs_to_many :locations, :uniq => true
  
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
  
  def puts(str)
    $stderr.puts str
    if self.output
      self.output << str + "\n"
    else
      self.output = str + "\n"
    end
    self.save!
  end
  
  def location_names
    if locations.empty?
      "Unknown" 
    else
      locations.join(", ")
    end
  end
  
  def subnets
    locations.map(&:subnets).flatten.uniq
  end
  
  def to_s
    read_attribute(:name)
  end
  
  def self.choices
    find(:all).map { |scan| [scan.name, scan.id.to_s] }
  end
  
  def self.run!
    scan = Scan.find_in_state(:first, :waiting, :order => 'starts_at')
    
    return unless scan && Time.now >= scan.starts_at

    scan.start!

    subnets         = scan.subnets.map(&:cidr).join(' ')
    cur_time        = Time.now
    nmap_results    = File.expand_path(cur_time.strftime(AppConfig.nmap_results_path))
    nessus_results  = File.expand_path(cur_time.strftime(AppConfig.nessus_results_path))
    nessus_plugins  = File.expand_path(cur_time.strftime(AppConfig.nessus_plugins_path))

    FileUtils.mkdir_p(File.dirname(nmap_results))
    FileUtils.mkdir_p(File.dirname(nessus_results))
    FileUtils.mkdir_p(File.dirname(nessus_plugins))
    
    scan.puts("Finding live hosts in #{subnets}...")
    `#{AppConfig.nmap_path} -n -sP -PE -PT -PM #{subnets} | grep -i "appears to be up" | cut -d" " -f2 > #{nmap_results}`
    scan.puts("Nmap results saved to #{nmap_results}")
    
    scan.puts("Scanning live hosts in #{subnets}...")
    `#{AppConfig.nessus_path} -T nessus #{nmap_results} #{nessus_results}`
    scan.puts("Nessus results saved to #{nessus_results}")
    
    scan.puts("Retrieving plugins from Nessus...")
    `#{AppConfig.nessus_path} -p > #{nessus_plugins}`
    scan.puts("Nessus plugins saved to #{nessus_plugins}")
    
    Nessus.process(scan, nessus_results, nessus_plugins)

    scan.stop!
  end
end
