class Family < ActiveRecord::Base
  after_create :add_classifications!

  has_many :plugins

  def to_s
    name
  end

  def self.choices
    Family.find(:all).map { |family| [family.name, family.id.to_s] }
  end


  private
    def add_classifications!
      Risk.find(:all).each do |risk|
        PluginClassification.create(:family => self, :risk => risk)
      end
    end
end
