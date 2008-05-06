class Plugin < ActiveRecord::Base
  OS_DETECTION  = 11936
  TRACEROUTE    = 10287
  SERVICE       = 10330
  HOST_FDQN     = 12053
  
  after_create :add_plugin_severities!
  before_save :update_classification
  after_save :update_plugin_severities!
  after_save :update_vulnerability_severities!
  
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
    plugin_severities.find_by_location_id(location.id).severity
  end
  
  def update_vulnerability_severities!
    vulnerabilities.map(&:update_severity!)
  end
  
  def update_plugin_severities!
    plugin_severities.map(&:update_severity!)
  end
  
  def classify!
    classification_id = PluginClassification.classify(risk, family).id rescue nil
    
    write_attribute(:classification_id, classification_id)
    save!
  end
  
  private
    def add_plugin_severities!
      Location.find(:all).each do |location| 
        plugin_severities.create(:location => location)
      end
    end
    
    def update_classification
      self.classification = PluginClassification.classify(self.risk, self.family)
    end
end
