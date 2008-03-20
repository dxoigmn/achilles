class Classification < ActiveRecord::Base
  after_create :add_severities

  has_many :plugins
  has_many :severities
  
  def to_s
    name
  end

  private
    def add_severities
      Location.find(:all).each do |location|
        severity                = Severity.new()
        severity.classification = self
        severity.location       = location
        severity.severity       = nil
        severity.save!
      end
    end
end
