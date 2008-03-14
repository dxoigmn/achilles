class Location < ActiveRecord::Base
  has_and_belongs_to_many :scans
  has_many :hosts
  has_many :subnets
  has_many :plugin_severities
  has_many :vulnerability_severities
  
  def to_s
    read_attribute(:name)
  end
  
  def self.locate(ip_address)
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
