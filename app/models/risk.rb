class Risk < ActiveRecord::Base
  has_many :plugins

  def to_s
    name
  end
  
  def self.choices
    Risk.find(:all).map { |risk| [risk.name, risk.id] }
  end
end
