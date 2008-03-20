class Location < ActiveRecord::Base
  has_and_belongs_to_many :scans, :uniq => true
  has_many :hosts
  has_many :subnets
  has_many :plugin_severities
  has_many :severities
  
  def to_s
    name
  end
  
  def self.locate(ip)
    ip_address = nil

    case ip
    when Fixnum
      ip_address = ip
    when String
      ip_address = NetAddr.ip_to_i(ip)
    else
      fail "ip must be of type Fixnum or String: #{ip.class}"
    end
    
    subnet = Subnet.find(:first,
                         :conditions => ["? BETWEEN lowest_ip_address AND highest_ip_address", ip_address],
                         :include => :location)
    
    if subnet
      subnet.location 
    else
      nil
    end
  end
end
