class Severity < ActiveRecord::Base
  after_save :update_classification_plugin_severities!
  
  belongs_to :classification
  belongs_to :location
  
  def self.choices
    [['Deferred', ''],
     ['1', 1],
     ['2', 2],
     ['3', 3],
     ['4', 4],
     ['5', 5]]
  end
  
  def update_classification_plugin_severities!
    classification.plugins.map(&:update_plugin_severities!)
  end
end
