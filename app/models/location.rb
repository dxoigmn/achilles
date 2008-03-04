class Location < ActiveRecord::Base
  has_many :scans
  
  def to_s
    read_attribute(:name)
  end
end
