class Severity < ActiveRecord::Base
  belongs_to :classification
  belongs_to :location
  
  def self.severify(classification, location)
    location_id       = nil
    
    case location
    when Fixnum
      location_id = location
    when Location
      location_id = location.id
    else
      fail "location must be an id or Family"
    end
    
    severity = nil

    if Fixnum === classification
      severity = Severity.find(:first, :conditions => { :classification_id => classification, :location_id => location_id }).severity rescue nil
    elsif Classification === classification
      classification.severities.each do |classification_severity|
        severity = classification_severity.severity if classification_severity.location_id == location_id
      end
    else
      fail "classification must be an id or Family"
    end
    
    severity
  end
end
