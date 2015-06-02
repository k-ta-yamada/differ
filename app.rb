require 'active_support'
require 'active_support/core_ext/numeric'
require 'active_support/core_ext/string/inflections'

require './lib/app_config.rb'
require './models/models'
require './lib/differ'

if AppConfig.environment == :benchmark
  # require 'profile'
  puts 'benchmark do perform!!'
  Benchmark.measure {
    Differ.new(limit: 100_000, search_value: 44).do_perform
  }
end
