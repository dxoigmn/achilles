class Family < ActiveRecord::Base
  has_many :plugins
  
  def to_s
    name
  end
  
  def self.choices
    Family.find(:all).map { |family| [family.name, family.id] }
  end
end
