class Severity < ActiveRecord::Base
  belongs_to :classification
  belongs_to :location
  
  def self.choices
    [['Deferred', nil], 1, 2, 3, 4, 5]
  end
end
