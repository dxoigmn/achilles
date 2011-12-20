class User < ActiveRecord::Base
  has_and_belongs_to_many :locations, :uniq => true

  def is_admin?
    Location.find(:all).inject(true) { |is_admin, location| is_admin && locations.include?(location)}
  end
end
