class Plugin < ActiveRecord::Base
  has_many :vulnerabilities
end
