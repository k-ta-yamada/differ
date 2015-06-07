require 'active_record'
require 'active_record/diff'
require 'activerecord-import'

ActiveRecord::Base.logger =
  Logger.new('./log/ActiveRecord.log', 5, 500.megabyte)

ActiveRecord::Base.logger.level =
  AppConfig.environment == :production ? Logger::INFO : Logger::DEBUG

ActiveRecord::Base.establish_connection(AppConfig.database)

# require all model files
Dir[File.expand_path('../', __FILE__) << '/*.rb'].each do |file|
  require file unless file == __FILE__
end
