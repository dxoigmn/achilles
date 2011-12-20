class Risk < ActiveRecord::Base
  after_create :add_classifications!

  has_many :plugins

  def to_s
    name
  end

  def self.choices
    Risk.find(:all).map { |risk| [risk.name, risk.id.to_s] }
  end

  private
    def add_classifications!
      Family.find(:all).each do |family|
        PluginClassification.create(:family => family, :risk => self)
      end
    end
end
