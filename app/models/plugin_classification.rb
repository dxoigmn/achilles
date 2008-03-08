class PluginClassification < ActiveRecord::Base
  belongs_to :classification
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
      fail "risk must be an id of Family"
    end
    
    case family
    when Fixnum
      family_id = family
    when Family
      family_id = family.id
    else
      fail "family must be an id of Family"
    end
    
    PluginClassification.find(:first, :conditions => { :risk_id => risk_id, :family_id => family_id }).classification rescue nil
  end
end
