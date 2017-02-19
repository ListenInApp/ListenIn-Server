require 'json'
require 'bcrypt'
require 'sinatra'
require 'fileutils'
require 'active_record'

require_relative 'models/master'

# Read the configuration file
begin
  $CONFIG = YAML.load_file('config.yml').freeze
  $ROOT = File.dirname(__FILE__)

  def assert_config(field)
    if not $CONFIG.has_key?(field)
      raise "Missing field #{field} in config.yml"
    end
  end

  assert_config(:connection)
  assert_config(:replay_time)
  assert_config(:upload_directory)
rescue Exception => e
  puts e
  puts "The config file (config.yml) may be missing certain fields or non-existent"
  exit 1
end

ActiveRecord::Base.establish_connection($CONFIG[:connection])

class App < Sinatra::Base
  require_relative 'routes/main'
end
