class Subnet < ActiveRecord::Base
  belongs_to :location

  def cidr=(value)
    value = NetAddr::CIDR.create(value)
    
    write_attribute(:lowest_ip_address, NetAddr.ip_to_i(value.first))
    write_attribute(:highest_ip_address, NetAddr.ip_to_i(value.last))
  end

  def cidr
    "#{NetAddr.i_to_ip lowest_ip_address}/#{32 - ((lowest_ip_address == highest_ip_address) ? 0 : (lowest_ip_address ^ highest_ip_address).to_s(2).length)}"
  end
end
