class Classification < ActiveRecord::Base
  has_many :plugins
  has_many :vulnerability_severities
  
  def to_s
    name
  end
end
