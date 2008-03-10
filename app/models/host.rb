class Host < ActiveRecord::Base
  has_many :vulnerabilities
  has_many :severities, :through => :vulnerabilities
  belongs_to :location, :counter_cache => true
  belongs_to :scan, :counter_cache => true
  
  def ip
    NetAddr.i_to_ip(read_attribute(:ip))
  end
  
  def ip=(value)
    value = NetAddr.ip_to_i(value)
    
    write_attribute(:ip, value)
    self.location = Location.locate(value)
  end
  
  def os_detected?
    !os_detection.nil?
  end
  
  def os_detection
    vulnerabilities.find_by_plugin_id(Plugin::OS_DETECTION).data rescue nil
  end
  
  def tracerouted?
    !traceroute.nil?
  end
  
  def traceroute
    vulnerabilities.find_by_plugin_id(Plugin::TRACEROUTE).data rescue nil
  end
  
  def severity
    severities.sort_by(&:value).last
  end
end
