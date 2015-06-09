require 'active_support'
require 'active_support/core_ext/numeric'
require 'active_support/core_ext/string/inflections'
require 'ap'

require './lib/app_config.rb'
require './lib/differ'

puts 'AppConfig.environment=[#{AppConfig.environment}]'
ap AppConfig.environment
puts 'AppConfig.database=[#{AppConfig.database}]'
ap AppConfig.database
# puts 'AppConfig.models=[#{AppConfig.models}]'
# ap AppConfig.models
# puts 'AppConfig.differ=[#{AppConfig.differ}]'
# ap AppConfig.differ
# puts
