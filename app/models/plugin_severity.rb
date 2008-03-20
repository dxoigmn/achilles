class PluginSeverity < ActiveRecord::Base
  belongs_to :plugin
  belongs_to :location
end
