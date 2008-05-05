include FixtureHelpers

status :name => 'Open (Needs Remediation)', :default => true
status :name => 'Closed (Remediated)'
status :name => 'Logged (No Remediation Necessary)'

classification :name => 'Disclosure'
classification :name => 'Compromised'

localize :name => 'localhost', :cidr => '127.0.0.1/32', :as => 'Local'

user :name => '', :locations => ['Local']