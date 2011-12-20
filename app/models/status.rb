class Status < ActiveRecord::Base
  has_many :vulnerabilities
  has_many :plugins

  def to_s
    name
  end

  def self.default
    Status.find(:first, :conditions => { :default => true })
  end

  def self.choices
    Status.find(:all).map { |status| [status.name, status.id.to_s] }
  end
end
