class Subnet < ActiveRecord::Base
  belongs_to :location

  def cidr
    "#{NetAddr.i_to_ip lowest_ip_address}/#{32 -(lowest_ip_address ^ highest_ip_address).to_s(2).length}"
  end
end
