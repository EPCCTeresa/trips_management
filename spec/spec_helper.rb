# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails'
puts 'SimpleCov started successfully!'

require 'bundler/setup'
Bundler.require(:default)
Bundler.require(:test)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.order = :random
  Kernel.srand config.seed
end
