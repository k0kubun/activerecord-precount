require 'config'

require 'active_record'
require 'activerecord-count_loader'
require 'volatile_counter_cache'

require 'support/config'
require 'support/connection'

# Connect to the database
ARTest.connect

def load_schema
  # silence verbose schema loading
  original_stdout = $stdout
  $stdout = StringIO.new

  adapter_name = ActiveRecord::Base.connection.adapter_name.downcase

  load SCHEMA_ROOT + "/schema.rb"
ensure
  $stdout = original_stdout
end

load_schema
