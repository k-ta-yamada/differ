# @ref 非Rails AppでActiveRecord::Migrationを使う + Rakeでバージョン管理する
# @url http://qiita.com/foloinfo/items/6ecfe3c5fd1b56f1dceb
require 'active_record'
require 'yaml'
require 'erb'
require 'logger'

task default: :migrate

desc 'Migrate database'
task migrate: :environment do
  ActiveRecord::Migrator
    .migrate('db/migrate', ENV['VERSION'] ? ENV['VERSION'].to_i : nil)
end

task :environment do
  dbconfig = YAML.load(ERB.new(File.read('config/database.yml')).result)
  ActiveRecord::Base
    .establish_connection(dbconfig[ENV['ENV'] ? ENV['ENV'].to_sym : :development])
  ActiveRecord::Base.logger = Logger.new('log/migrate.log')
end
