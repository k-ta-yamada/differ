require 'active_record'
require 'active_record/diff'
require 'activerecord-import'

ActiveRecord::Base.logger = Logger.new('./log/ActiveRecord.log', 5, 5.megabyte)
ActiveRecord::Base.establish_connection(AppConfig.database)

# require all model files
Dir[File.expand_path('../', __FILE__) << '/*.rb'].each do |file|
  next if file == __FILE__
  require file
end
