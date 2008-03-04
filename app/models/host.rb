class Host < ActiveRecord::Base
  has_many :vulnerabilities
  belongs_to :scan, :counter_cache => true
  
  def ip
    NetAddr.i_to_ip(read_attribute(:ip))
  end
  
  def ip=(value)
    write_attribute(:ip, NetAddr.ip_to_i(value))
  end
end
