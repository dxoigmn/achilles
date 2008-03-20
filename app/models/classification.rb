class Classification < ActiveRecord::Base
  after_create :add_severities

  has_many :plugins
  has_many :severities
  
  def to_s
    name
  end

  private
    def add_severities
      Location.find(:all).each { |location| severities.create(:location => location) }
    end
end
