class Classification < ActiveRecord::Base
  has_many :plugins
  has_many :severities
  
  def to_s
    name
  end
end
