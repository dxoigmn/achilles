class Status < ActiveRecord::Base
  has_many :vulnerabilities
  has_many :plugins
  
  def to_s
    name
  end
  
  def self.default
    Status.find(:first, :conditions => { :default => true })
  end
end
