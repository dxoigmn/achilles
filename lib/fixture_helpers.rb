module FixtureHelpers
  def status(options)
    fail unless options[:name]

    status = Status.find_or_create_by_name(options[:name])
    
    if options[:default]
      status.default = true
      status.save!
    end
  end
  
  def classification(options)
    fail unless options[:name]
    
    classification = Classification.find_or_create_by_name(options[:name])
  end

  def user(options)
    fail unless options[:name]
    
    user = User.find_or_create_by_name(options[:name])
    
    options[:locations].each { |location| user.locations << Location.find_by_name(location) } if options[:locations]
  end
  
  def severify(options)
    options[:location_id]       = Location.find_or_create_by_name(options.delete(:location)).id             if options[:location]
    options[:classification_id] = Classification.find_or_create_by_name(options.delete(:classification)).id if options[:classification]
    options[:severity]          = options.delete(:as)                                                       if options[:as]
  
    fail unless options[:location_id] &&
                options[:classification_id] &&
                options[:severity]
  
    severity = Severity.find(:first, :conditions => { :location_id => options[:location_id], 
                                                      :classification_id => options[:classification_id] })

    unless severity
      severity                    = Severity.new
      severity.location_id        = options[:location_id]
      severity.classification_id  = options[:classification_id]
    end
  
    severity.severity = options[:severity]  
    severity.save!
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
  
  def plugin(options)
    options[:family_id] = Family.find_or_create_by_name(options[:family]) if options[:family]
    options[:risk_id]   = Risk.find_or_create_by_name(options[:risk]) if options[:risk]
    
    fail unless options[:id] &&
                options[:name] &&
                options[:category] &&
                options[:family_id] &&
                options[:risk_id] &&
                options[:summary]
    
    plugin            = Plugin.new
    plugin.id         = options[:id]
    plugin.name       = options[:name]
    plugin.category   = options[:category]
    plugin.family_id  = options[:family_id]
    plugin.risk_id    = options[:risk_id]
    plugin.summary    = options[:summary]
    plugin.save!
  end
end