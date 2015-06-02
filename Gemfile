# A sample Gemfile
source 'https://rubygems.org'

ruby '2.1.5'

gem 'pry'
gem 'pry-doc'
gem 'pry-byebug'
gem 'pry-theme'
gem 'awesome_print'

group :production do
  gem 'ruby-oci8'
  # gem 'activerecord-oracle_enhanced-adapter'
  # ref: https://github.com/rails/rails/issues/18739
  gem 'activerecord-oracle_enhanced-adapter',
      git: 'https://github.com/rsim/oracle-enhanced',
      branch: 'rails42'
end

group :test, :development do
  gem 'sqlite3'
end

group :test do
  gem 'rspec'
  gem 'fuubar', '~> 2.0.0'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
end

gem 'activerecord'
gem 'activerecord-diff'
# gem 'activerecord-import'

# gem 'parallel'

# gem 'ruby-plsql-spec'
# gem 'factory_girl'
