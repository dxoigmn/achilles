class Severity < ActiveRecord::Base
  has_many :vulnerabilities
end
