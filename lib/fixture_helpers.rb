require 'rubygems'
require 'netaddr'

module FixtureHelpers
  def severity(options = {})
    fail unless options[:value] &&
                options[:name]
              
    severity        = Severity.find_or_create_by_name(options[:name])
    severity.value  = options[:value]
    severity.save!
  end

  def severify(options)
    options[:location_id]       = Location.find_or_create_by_name(options.delete(:location)).id             if options[:location]
    options[:classification_id] = Classification.find_or_create_by_name(options.delete(:classification)).id if options[:classification]
    options[:severity_id]       = Severity.find_or_create_by_name(options.delete(:as)).id                   if options[:as]
  
    fail unless options[:location_id] &&
                options[:classification_id] &&
                options[:severity_id]
  
    vulnerability_severity = VulnerabilitySeverity.find(:first, :conditions => { :location_id => options[:location_id], 
                                                                                 :classification_id => options[:classification_id] })

    unless vulnerability_severity
      vulnerability_severity                    = VulnerabilitySeverity.new
      vulnerability_severity.location_id        = options[:location_id]
      vulnerability_severity.classification_id  = options[:classification_id]
    end
  
    vulnerability_severity.severity_id = options[:severity_id]  
    vulnerability_severity.save!
  end
  
  def classify(options)
    options[:risk_id]           = Risk.find_or_create_by_name(options.delete(:risk)).id         if options[:risk]
    options[:family_id]         = Family.find_or_create_by_name(options.delete(:family)).id     if options[:family]
    options[:classification_id] = Classification.find_or_create_by_name(options.delete(:as)).id if options[:as]

    fail unless options[:family_id] &&
                options[:risk_id] &&
                options[:classification_id]

    plugin_classification = PluginClassification.find(:first, :conditions => { :family_id  => options[:family_id], 
                                                                               :risk_id    => options[:risk_id] })

    unless plugin_classification
      plugin_classification           = PluginClassification.new
      plugin_classification.family_id = options[:family_id]
      plugin_classification.risk_id   = options[:risk_id]
    end

    plugin_classification.classification_id = options[:classification_id]
    plugin_classification.save!
  end
  
  def localize(options)
    if options[:cidr]
      cidr = NetAddr::CIDR.create(options.delete(:cidr))

      options[:lowest_ip_address]   = NetAddr.ip_to_i(cidr.first)
      options[:highest_ip_address]  = NetAddr.ip_to_i(cidr.last)
    end

    options[:location_id] = Location.find_or_create_by_name(options.delete(:as)).id if options[:as]

    fail unless options[:name] &&
                options[:lowest_ip_address] &&
                options[:highest_ip_address] &&
                options[:location_id]

    subnet                    = Subnet.find_or_create_by_name(options[:name])
    subnet.lowest_ip_address  = options[:lowest_ip_address]
    subnet.highest_ip_address = options[:highest_ip_address]
    subnet.location_id        = options[:location_id]
    subnet.save!
  end
end