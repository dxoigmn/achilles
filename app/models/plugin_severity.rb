class PluginSeverity < ActiveRecord::Base
  belongs_to :plugin
  
  def self.severify(plugin, location)
    plugin_id   = nil
    location_id = nil
    
    case plugin
    when Fixnum
      plugin_id = plugin
    when Plugin
      plugin_id = plugin.id
    else
      fail "plugin must be an id or Plugin"
    end
    
    case location
    when Fixnum
      location_id = location
    when Location
      location_id = location.id
    else
      fail "location must be an id or Family"
    end
    
    PluginSeverity.find(:first, :conditions => { :plugin_id => plugin_id, :location_id => location_id }).severity rescue nil
  end
end
