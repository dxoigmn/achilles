class Plugin < ActiveRecord::Base
  OS_DETECTION  = 11936
  TRACEROUTE    = 10287
  SERVICE       = 10330
  HOST_FDQN     = 12053

  has_many :vulnerabilities
  has_many :hosts, :through => :vulnerabilities
  has_many :plugin_severities
  has_many :severities

  belongs_to :family
  belongs_to :risk
  belongs_to :classification
  
  def visible?
    read_attribute(:visible)
  end

  def visible
    read_attribute(:visible).to_s.capitalize
  end

  def severity(location)
    PluginSeverity.severify(self, location) ||
    Severity.severify(self.classification, location)
  end
end
