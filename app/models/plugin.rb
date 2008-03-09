class Plugin < ActiveRecord::Base
  OS_DETECTION  = 11936
  TRACEROUTE    = 10287
  SERVICE       = 10330
  HOST_FDQN     = 12053

  has_many :vulnerabilities
  has_many :hosts, :through => :vulnerabilities

  belongs_to :family
  belongs_to :risk
  belongs_to :classification
  
  def severity(location)
    PluginSeverity.severify(self, location) ||
    VulnerabilitySeverity.severify(self.classification, location)
  end
end
