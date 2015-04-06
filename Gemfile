source 'https://rubygems.org'
ruby '2.2.1'

###############################################################################
# Default Stuff                                                               #
###############################################################################

gem 'rails', '4.2.1'

# Database.
gem 'pg'

# Webserver
gem 'unicorn'

# Logs
gem 'lograge'

# Async processes
gem 'sucker_punch'

###############################################################################
# Assets, Views & Routes                                                      #
###############################################################################

# CSS
gem 'sass-rails'
gem 'uglifier'
gem 'bourbon'
gem 'neat'

# JS
gem 'coffee-rails'
gem 'active_model_serializers'
gem 'js-routes'

# Views
gem 'haml-rails'

###############################################################################
# Environments                                                                #
###############################################################################

group :test, :development do
  gem 'dotenv-rails'
  gem 'byebug'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :test do
  gem 'webmock'
  gem 'vcr'
  gem 'faker'
  gem 'shoulda-matchers', require: false
  gem 'codeclimate-test-reporter', require: nil
end

group :development do
  gem 'pry-rails'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'annotate'
end

group :production do
  gem 'rails_12factor'
end

###############################################################################
# Application                                                                 #
###############################################################################

# Authentification
gem 'omniauth'
gem 'omniauth-foursquare'

# 4sq
gem 'foursquare2'

# Locations
gem 'geokit'
gem 'geokit-rails'

# Pretty URLs
gem 'friendly_id'
