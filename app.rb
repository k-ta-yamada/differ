require 'active_support'
require 'active_support/core_ext/numeric'
require 'active_support/core_ext/string/inflections'

require 'ap'

require './lib/app_config.rb'
require './models/models'
require './lib/differ'

puts "AppConfig.environment=[#{AppConfig.environment}]"
# puts 'AppConfig.database=[#{AppConfig.database}]'
# ap AppConfig.database
# puts 'AppConfig.models=[#{AppConfig.models}]'
# ap AppConfig.models
# puts 'AppConfig.differ=[#{AppConfig.differ}]'
# ap AppConfig.differ
# puts

# if AppConfig.environment == :benchmark
#   # require 'profile'
#   Differ.do_perform_with_benchmark
#   exit
# end
