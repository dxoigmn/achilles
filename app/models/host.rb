class Host < ActiveRecord::Base
  has_many :vulnerabilities
  has_many :severities, :through => :vulnerabilities
  belongs_to :location#, :counter_cache => true
  belongs_to :scan#, :counter_cache => true
  
  def ip
    NetAddr.i_to_ip(read_attribute(:ip))
  end
  
  def ip=(value)
    value = NetAddr.ip_to_i(value)
    
    unless value == read_attribute(:ip)
      write_attribute(:ip, value)
      self.location = Location.locate(value)
    end
  end
  
  def os_detected?
    !os_detection.nil?
  end
  
  def os_detection
    data = nil

    vulnerabilities.each do |vulnerability| 
      data = vulnerability.data if vulnerability.plugin_id == Plugin::OS_DETECTION
    end
    
    data
  end
  
  def tracerouted?
    !traceroute.nil?
  end
  
  def traceroute
    data = nil

    vulnerabilities.each do |vulnerability| 
      data = vulnerability.data if vulnerability.plugin_id == Plugin::TRACEROUTE
    end
    
    data
  end
  
  def severity
    vulnerabilities.map(&:severity).sort_by(&:value).last
  end
end
