include FixtureHelpers

status :name => 'Open (Needs Remediation)', :default => true
status :name => 'Closed (Remediated)'
status :name => 'Logged (No Remediation Necessary)'

localize :name => 'Local',      :cidr => '127.0.0.1/32',     :as => 'Local'

classification :name => 'Compromised'
classification :name => 'Full Control - Remote'
classification :name => 'Full Control - Local'
classification :name => 'System User Access'
classification :name => 'DoS - System'
classification :name => 'DoS - Service'
classification :name => 'Degradation - System'
classification :name => 'Degradation - Service'
classification :name => 'Data Disclosure - Full'
classification :name => 'Data Disclosure - Partial'
classification :name => 'Data Corruption'
classification :name => 'System Info Disclosure'
classification :name => 'Service Control'

user :name => '', :locations => ['Local']