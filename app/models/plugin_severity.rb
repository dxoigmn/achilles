class PluginSeverity < ActiveRecord::Base
  belongs_to :plugin
  
  def self.severify(plugin, location)
    location_id = nil
        
    case location
    when Fixnum
      location_id = location
    when Location
      location_id = location.id
    else
      fail "location must be of type Fixnum or Location: #{location.class}"
    end

    severity = nil

    if Fixnum === plugin
      severity = PluginSeverity.find(:first, :conditions => { :plugin_id => plugin.id, :location_id => location_id }).severity rescue nil
    elsif Plugin === plugin
      plugin.plugin_severities.each do |plugin_severity|
        severity = plugin_severity.severity if plugin_severity.location_id == location_id
      end
    else
      fail "plugin must be of type Fixnum or Plugin: #{plugin.class}"
    end
    
    severity
  end
end
