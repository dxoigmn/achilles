require 'ostruct'

AppConfig = OpenStruct.new(YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV])
