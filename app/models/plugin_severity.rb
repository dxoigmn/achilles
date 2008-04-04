class PluginSeverity < ActiveRecord::Base
  before_create :update_severity
  after_save :update_plugin_vulnerability_severities!
  
  belongs_to :plugin
  belongs_to :location
  
  acts_as_modifiable(:severity) do
    plugin.severities.find_by_location_id(location.id).severity rescue nil
  end
  
  def update_plugin_vulnerability_severities!
    plugin.update_vulnerability_severities!
  end
end
