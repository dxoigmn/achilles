class Classification < ActiveRecord::Base
  has_many :plugins
  
  def to_s
    name
  end
end
