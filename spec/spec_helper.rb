# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter 'spec/'
end

require 'bundler/setup'
Bundler.require(:default)
Bundler.require(:test)

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.around do |example|
    DB.transaction(rollback: :always, auto_savepoint: true) { example.run }
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.order = :random
  Kernel.srand config.seed
end
