class Host < ActiveRecord::Base
  has_many :vulnerabilities
  belongs_to :scan
end
