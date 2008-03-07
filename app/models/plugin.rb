class Plugin < ActiveRecord::Base
  has_many :vulnerabilities
  has_many :hosts, :through => :vulnerabilities
  
  OS_DETECTION  = 11936
  TRACEROUTE    = 10287
end
