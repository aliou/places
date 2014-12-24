# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

OmniAuth.config.test_mode = true

RSpec.configure do |config|
  config.include OauthHelper
  config.include FoursquareAPIHelper

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!
end
