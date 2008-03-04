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
    puts str
    output << str + "\n"
    save!
  end
  
  def self.run!
    scan = Scan.find_in_state(:first, :waiting, :order => 'starts_at')
    
    return unless scan && Time.now >= scan.starts_at

    scan.start!
    scan.output!("Executing nessus....")
    
    # TODO: Execute nessus to output to file

    Nessus.process(scan, File.join(RAILS_ROOT, 'data', 'results.xml'))

    scan.stop!
  end
end
