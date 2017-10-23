# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'database_cleaner'
require 'capybara/rspec'
require 'email_spec'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

Capybara.app_host = 'http://example.com'

Rails.application.routes.default_url_options[:host] = 'www.example.com'

RSpec.configure do |config|

  config.include Capybara::DSL
  config.include Rails.application.routes.url_helpers

  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller

  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers

  config.include Shoulda::Matchers::ActiveModel, type: :model
  config.include Shoulda::Matchers::ActiveRecord, type: :model
  # config.include Paperclip::Shoulda::Matchers

  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    Rails.application.load_seed # loading seeds
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
#    drop_schemas
    Capybara.app_host = 'http://example.com'
    reset_mailer
  end

end
