class PluginClassification < ActiveRecord::Base
  belongs_to :classification
  belongs_to :risk
  belongs_to :family
  has_many :plugins, :finder_sql => 'SELECT plugins.* FROM plugins ' +
                                    'WHERE plugins.family_id = #{family_id} AND ' +
                                    '      plugins.risk_id = #{risk_id}'

  def self.classify(risk, family)
    risk_id   = nil
    family_id = nil
    
    case risk
    when Fixnum
      risk_id = risk
    when Risk
      risk_id = risk.id
    else
      fail "risk must be of type Fixnum or Family: #{risk.class}"
    end
    
    case family
    when Fixnum
      family_id = family
    when Family
      family_id = family.id
    else
      fail "family must be of type Fixnum or Family: #{risk.class}"
    end

    plugin_classification = PluginClassification.find(:first, :conditions => { :risk_id => risk_id, :family_id => family_id })
    
    if plugin_classification
      plugin_classification.classification
    else
      nil
    end
  end
end
