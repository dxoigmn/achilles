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
  
  def output!(str)
    puts str
    if output
      output << str + "\n"
    else
      output = str + "\n"
    end
    save!
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
  
  def self.run!
    scan = Scan.find_in_state(:first, :waiting, :order => 'starts_at')
    
    return unless scan && Time.now >= scan.starts_at

    scan.start!

    subnets         = scan.subnets.map(&:cidr).join(' ')
    cur_time        = Time.now
    nmap_results    = File.expand_path(cur_time.strftime(AppConfig.nmap_results_path))
    nessus_results  = File.expand_path(cur_time.strftime(AppConfig.nessus_results_path))
    
    scan.output!("Finding live hosts in #{subnets}...")
    `#{AppConfig.nmap_path} -n -sP -PE -PT -PM #{subnets} | grep -i "appears to be up" | cut -d" " -f2 > #{nmap_results}`
    scan.output!("Nmap results saved to #{nmap_results}")
    scan.output!("Scaning live hosts in #{subnets}...")
    `#{AppConfig.nessus_path} -T xml #{nmap_results} #{nessus_results}`
    scan.output!("Nessus results saved to #{nessus_results}")

    Nessus.process(scan, nessus_results)

    scan.stop!
  end
end
