class Classification < ActiveRecord::Base
  after_create :add_severities!

  has_many :plugins
  has_many :severities
  
  def to_s
    name
  end

  def self.choices
    Classification.find(:all).map { |classification| [classification.name, classification.id] }
  end

  private
    def add_severities!
      Location.find(:all).each do |location| 
        severities.create(:location => location)
      end
    end
end
