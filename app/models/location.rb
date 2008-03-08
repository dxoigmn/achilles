class Location < ActiveRecord::Base
  has_and_belongs_to_many :scans
  has_many :hosts
  
  def to_s
    read_attribute(:name)
  end
end
