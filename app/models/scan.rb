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
    scan = Scan.find_in_state(:first, :waiting, :order => 'starts_at', :output => '')
    
    return unless scan && Time.now >= scan.starts_at

    scan.start!
    scan.output!("Executing nessus....")
    
    subnets = scan.subnets.map(&:cidr).join(' ')
    targets = File.join(RAILS_ROOT, 'data', 'scans', scan.name, 'targets')
    results = File.join(RAILS_ROOT, 'data', 'scans', scan.name, 'results')
    
    `nmap -sP -PE -PT -PM -oG #{targets}.nmap #{subnets}`
    `grep -i "Status: Up" #{targets}.nmap | cut -d" " -f2 > #{targets}.lst`
    `/data/opt/nessus/bin/nessus -T xml -q 127.0.0.1 1241 students students #{targets}.lst #{results}.xml`

    Nessus.process(scan, "#{results}.xml")

    scan.stop!
  end
end
