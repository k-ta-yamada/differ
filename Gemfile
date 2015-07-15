# A sample Gemfile
source 'https://rubygems.org'

ruby '2.1.5'

gem 'pry'
gem 'pry-doc'
gem 'pry-byebug'
gem 'pry-theme'

gem 'awesome_print'
gem 'parallel', '~> 1.6.0'
gem 'ruby-progressbar'

gem 'activerecord'
gem 'activerecord-diff'
gem 'activerecord-import'

group :production do
  gem 'ruby-oci8'
  gem 'activerecord-oracle_enhanced-adapter'
end

group :test, :development, :benchmark do
  gem 'sqlite3'
end

group :test do
  gem 'rubocop'
  gem 'rspec'
  gem 'fuubar', '~> 2.0.0'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'faker'
  gem 'fakefs'
end
