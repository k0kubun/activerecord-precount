source 'https://rubygems.org'

# Specify your gem's dependencies in activerecord-count_loader.gemspec
gemspec

group :development do
  case ENV['ARCONN']
  when 'sqlite3'  then gem 'sqlite3'
  when 'mysql2'   then gem 'mysql2'
  when 'postgres' then gem 'postgres'
  end
end
