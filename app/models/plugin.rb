class Plugin < ActiveRecord::Base
  OS_DETECTION  = 11936
  TRACEROUTE    = 10287
  SERVICE       = 10330
  HOST_FDQN     = 12053
  
  after_create :add_plugin_severities

  has_many :vulnerabilities
  has_many :hosts, :through => :vulnerabilities
  has_many :plugin_severities

  belongs_to :family
  belongs_to :risk
  belongs_to :classification
  
  delegate :severities, :to => :classification
  
  def visible?
    read_attribute(:visible)
  end

  def visible
    read_attribute(:visible).to_s.capitalize
  end
  
  def severity(location)
    plugin_severities.find_by_location_id(location.id).severity ||
    severities.find_by_location_id(location.id).severity
  end
  
  private
    def add_plugin_severities
      Location.find(:all).each { |location| plugin_severities.create(:location => location) }
    end
end
