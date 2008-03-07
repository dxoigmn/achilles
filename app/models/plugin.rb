class Plugin < ActiveRecord::Base
  has_many :vulnerabilities
  has_many :hosts, :through => :vulnerabilities
  belongs_to :family
  belongs_to :risk
  
  OS_DETECTION  = 11936
  TRACEROUTE    = 10287
  SERVICE       = 10330
  HOST_FDQN     = 12053
end
