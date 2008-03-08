class Host < ActiveRecord::Base
  has_many :vulnerabilities
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
  
  def os_detection
    vulnerabilities.find_by_plugin_id(Plugin::OS_DETECTION) || nil
  end
  
  def traceroute
    vulnerabilities.find_by_plugin_id(Plugin::TRACEROUTE) || nil
  end
  
  def services
    vulnerabilities.find(:all).group_by(&:service)
  end
end
