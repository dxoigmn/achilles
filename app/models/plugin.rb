class Plugin < ActiveRecord::Base
  has_many :vulnerabilities
  has_many :hosts, :through => :vulnerabilities
end
