def classify(options)
  options[:risk_id]           = Risk.find_or_create_by_name(options.delete(:risk)).id         if options[:risk]
  options[:family_id]         = Family.find_or_create_by_name(options.delete(:family)).id     if options[:family]
  options[:classification_id] = Classification.find_or_create_by_name(options.delete(:as)).id if options[:as]
  
  fail unless options[:family_id]
  fail unless options[:risk_id]
  fail unless options[:classification_id]
  
  plugin_classification = PluginClassification.find(:first, 
                                                    :conditions => { :family_id  => options[:family_id], 
                                                                     :risk_id    => options[:risk_id] })
  
  if plugin_classification
    ActiveRecord::Base.connection.execute "UPDATE plugin_classifications SET classification_id = #{options[:classification_id]} WHERE family_id = #{options[:family_id]} AND risk_id = #{options[:risk_id]}"
  else
    ActiveRecord::Base.connection.execute "INSERT INTO plugin_classifications (classification_id, family_id, risk_id) VALUES (#{options[:classification_id]}, #{options[:family_id]}, #{options[:risk_id]})"
  end
end

classify :family => 'Backdoors',                     :risk => 'Critical', :as => 'Compromised'
classify :family => 'Backdoors',                     :risk => 'High',     :as => 'Compromised'
classify :family => 'Backdoors',                     :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'Backdoors',                     :risk => 'Medium',   :as => 'System Info Disclosure'
classify :family => 'CGI abuses',                    :risk => 'Critical', :as => 'Full Control - Remote'
classify :family => 'CGI abuses',                    :risk => 'High',     :as => 'System User Access'
classify :family => 'CGI abuses',                    :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'CGI abuses',                    :risk => 'Medium',   :as => 'Data Corruption'
classify :family => 'CGI abuses : XSS',              :risk => 'Critical', :as => 'Data Corruption'
classify :family => 'CGI abuses : XSS',              :risk => 'High',     :as => 'Data Corruption'
classify :family => 'CGI abuses : XSS',              :risk => 'Low',      :as => 'Degradation - Service'
classify :family => 'CGI abuses : XSS',              :risk => 'Medium',   :as => 'Data Corruption'
classify :family => 'CISCO',                         :risk => 'Critical', :as => 'Full Control - Remote'
classify :family => 'CISCO',                         :risk => 'High',     :as => 'DoS - System'
classify :family => 'CISCO',                         :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'CISCO',                         :risk => 'Medium',   :as => 'DoS - Service'
classify :family => 'Databases',                     :risk => 'Critical', :as => 'Full Control - Remote'
classify :family => 'Databases',                     :risk => 'High',     :as => 'Data Disclosure - Partial'
classify :family => 'Databases',                     :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'Databases',                     :risk => 'Medium',   :as => 'DoS - Service'
classify :family => 'Debian Local Security Checks',  :risk => 'Critical', :as => 'Full Control - Remote'
classify :family => 'Debian Local Security Checks',  :risk => 'High',     :as => 'System User Access'
classify :family => 'Debian Local Security Checks',  :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'Debian Local Security Checks',  :risk => 'Medium',   :as => 'System Info Disclosure'
classify :family => 'Default Unix Accounts',         :risk => 'Critical', :as => 'Full Control - Remote'
classify :family => 'Default Unix Accounts',         :risk => 'High',     :as => 'System User Access'
classify :family => 'Default Unix Accounts',         :risk => 'Low',      :as => 'System User Access'
classify :family => 'Default Unix Accounts',         :risk => 'Medium',   :as => 'System User Access'
classify :family => 'Denial of Service',             :risk => 'Critical', :as => 'DoS - System'
classify :family => 'Denial of Service',             :risk => 'High',     :as => 'DoS - System'
classify :family => 'Denial of Service',             :risk => 'Low',      :as => 'DoS - Service'
classify :family => 'Denial of Service',             :risk => 'Medium',   :as => 'DoS - Service'
classify :family => 'FTP',                           :risk => 'Critical', :as => 'Full Control - Remote'
classify :family => 'FTP',                           :risk => 'High',     :as => 'System User Access'
classify :family => 'FTP',                           :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'FTP',                           :risk => 'Medium',   :as => 'Data Disclosure - Partial'
classify :family => 'Finger abuses',                 :risk => 'Critical', :as => 'Full Control - Remote'
classify :family => 'Finger abuses',                 :risk => 'High',     :as => 'Full Control - Remote'
classify :family => 'Finger abuses',                 :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'Finger abuses',                 :risk => 'Medium',   :as => 'System Info Disclosure'
classify :family => 'Firewalls',                     :risk => 'Critical', :as => 'Service Control'
classify :family => 'Firewalls',                     :risk => 'High',     :as => 'Service Control'
classify :family => 'Firewalls',                     :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'Firewalls',                     :risk => 'Medium',   :as => 'System Info Disclosure'
classify :family => 'Gain a shell remotely',         :risk => 'Critical', :as => 'Full Control - Remote'
classify :family => 'Gain a shell remotely',         :risk => 'High',     :as => 'System User Access'
classify :family => 'Gain a shell remotely',         :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'Gain a shell remotely',         :risk => 'Medium',   :as => 'System User Access'
classify :family => 'Gain root remotely',            :risk => 'Critical', :as => 'Full Control - Remote'
classify :family => 'Gain root remotely',            :risk => 'High',     :as => 'Full Control - Remote'
classify :family => 'Gain root remotely',            :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'Gain root remotely',            :risk => 'Medium',   :as => 'DoS - Service'
classify :family => 'General',                       :risk => 'Critical', :as => 'Full Control - Remote'
classify :family => 'General',                       :risk => 'High',     :as => 'System User Access'
classify :family => 'General',                       :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'General',                       :risk => 'Medium',   :as => 'System Info Disclosure'
classify :family => 'Misc.',                         :risk => 'Critical', :as => 'Full Control - Remote'
classify :family => 'Misc.',                         :risk => 'High',     :as => 'System User Access'
classify :family => 'Misc.',                         :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'Misc.',                         :risk => 'Medium',   :as => 'System Info Disclosure'
classify :family => 'NIS',                           :risk => 'Critical', :as => 'Full Control - Remote'
classify :family => 'NIS',                           :risk => 'High',     :as => 'System User Access'
classify :family => 'NIS',                           :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'NIS',                           :risk => 'Medium',   :as => 'System Info Disclosure'
classify :family => 'Netware',                       :risk => 'Critical', :as => 'Full Control - Remote'
classify :family => 'Netware',                       :risk => 'High',     :as => 'System User Access'
classify :family => 'Netware',                       :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'Netware',                       :risk => 'Medium',   :as => 'System Info Disclosure'
classify :family => 'Peer-To-Peer File Sharing',     :risk => 'Critical', :as => 'Data Disclosure - Partial'
classify :family => 'Peer-To-Peer File Sharing',     :risk => 'High',     :as => 'System Info Disclosure'
classify :family => 'Peer-To-Peer File Sharing',     :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'Peer-To-Peer File Sharing',     :risk => 'Medium',   :as => 'System Info Disclosure'
classify :family => 'RPC',                           :risk => 'Critical', :as => 'Full Control - Remote'
classify :family => 'RPC',                           :risk => 'High',     :as => 'System User Access'
classify :family => 'RPC',                           :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'RPC',                           :risk => 'Medium',   :as => 'System Info Disclosure'
classify :family => 'Remote file access',            :risk => 'Critical', :as => 'Data Disclosure - Full'
classify :family => 'Remote file access',            :risk => 'High',     :as => 'Data Disclosure - Partial'
classify :family => 'Remote file access',            :risk => 'Low',      :as => 'Data Disclosure - Partial'
classify :family => 'Remote file access',            :risk => 'Medium',   :as => 'Data Disclosure - Partial'
classify :family => 'SMTP problems',                 :risk => 'Critical', :as => 'Full Control - Remote'
classify :family => 'SMTP problems',                 :risk => 'High',     :as => 'System User Access'
classify :family => 'SMTP problems',                 :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'SMTP problems',                 :risk => 'Medium',   :as => 'DoS - Service'
classify :family => 'SNMP',                          :risk => 'Critical', :as => 'System User Access'
classify :family => 'SNMP',                          :risk => 'High',     :as => 'System Info Disclosure'
classify :family => 'SNMP',                          :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'SNMP',                          :risk => 'Medium',   :as => 'System Info Disclosure'
classify :family => 'Service detection',             :risk => 'Critical', :as => 'System Info Disclosure'
classify :family => 'Service detection',             :risk => 'High',     :as => 'System Info Disclosure'
classify :family => 'Service detection',             :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'Service detection',             :risk => 'Medium',   :as => 'System Info Disclosure'
classify :family => 'Useless services',              :risk => 'Critical', :as => 'DoS - System'
classify :family => 'Useless services',              :risk => 'High',     :as => 'DoS - System'
classify :family => 'Useless services',              :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'Useless services',              :risk => 'Medium',   :as => 'DoS - System'
classify :family => 'Web Servers',                   :risk => 'Critical', :as => 'Full Control - Remote'
classify :family => 'Web Servers',                   :risk => 'High',     :as => 'System User Access'
classify :family => 'Web Servers',                   :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'Web Servers',                   :risk => 'Medium',   :as => 'DoS - Service'
classify :family => 'Windows',                       :risk => 'Critical', :as => 'Full Control - Remote'
classify :family => 'Windows',                       :risk => 'High',     :as => 'System User Access'
classify :family => 'Windows',                       :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'Windows',                       :risk => 'Medium',   :as => 'DoS - System'
classify :family => 'Windows : Microsoft Bulletins', :risk => 'Critical', :as => 'Full Control - Remote'
classify :family => 'Windows : Microsoft Bulletins', :risk => 'High',     :as => 'System User Access'
classify :family => 'Windows : Microsoft Bulletins', :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'Windows : Microsoft Bulletins', :risk => 'Medium',   :as => 'DoS - System'
classify :family => 'Windows : User management',     :risk => 'Critical', :as => 'Full Control - Remote'
classify :family => 'Windows : User management',     :risk => 'High',     :as => 'System User Access'
classify :family => 'Windows : User management',     :risk => 'Low',      :as => 'System Info Disclosure'
classify :family => 'Windows : User management',     :risk => 'Medium',   :as => 'System Info Disclosure'