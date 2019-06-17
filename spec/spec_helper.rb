require 'active_record'
require 'pry'
require 'aws-sdk-s3'
require 'dotenv/load'
require 'activerecord-import'
require 'factory_bot'
require 'ffaker'

Dir[Dir.pwd + "/app/**/*.rb"].each { |f| require f }
Dir[Dir.pwd + "/spec/support/**/*.rb"].each { |f| require f }

db_configuration_file = File.join(File.expand_path('..', __FILE__), '..', 'db', 'config.yml')
db_config = YAML.load(File.read(db_configuration_file))
ActiveRecord::Base.establish_connection(db_config["test"])

FactoryBot.definition_file_paths = %w{./factories ./test/factories ./spec/factories}
FactoryBot.find_definitions

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
