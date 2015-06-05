require 'database_cleaner'
# @ref [翻訳+α] Rails/RSpec/Capybara/Seleniumでdatabase_cleaner gemを使う | TechRacho
# @url http://techracho.bpsinc.jp/hachi8833/2014_05_28/17557

RSpec.configure do |config|
  config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }
  # config.before(:context) {  }
  # config.before(:example) {  }
  config.before(:each) { DatabaseCleaner.strategy = :transaction }
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }
end
