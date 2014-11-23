source 'https://rubygems.org'

# Specify your gem's dependencies in activerecord-count_loader.gemspec
gemspec

group :development do
  case ENV['ARCONN']
  when 'mysql2'
    gem 'mysql2'
  when 'postgres'
    gem 'postgres'
  else
    gem 'sqlite3'
  end

  unless ENV['TASK'] == 'test'
    gem 'pry'
  end

  if ENV['TASK'].nil? || ENV['TASK'] == 'benchmark'
    gem 'rbench', github: 'miloops/rbench'
  end
end

