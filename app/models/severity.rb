class Severity < ActiveRecord::Base
  has_many :vulnerabilities
  
  def to_s
    name
  end
end
