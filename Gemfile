source 'https://rubygems.org'
ruby '2.2.2'

###############################################################################
# Default Stuff                                                               #
###############################################################################

gem 'rails', '4.2.1'
gem 'responders'
gem 'bundler', '>= 1.8.4'

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

# JS
gem 'coffee-rails'
gem 'jquery-rails'
gem 'active_model_serializers'
gem 'js-routes'
gem 'sprockets-es6'

source 'https://rails-assets.org' do
  gem 'rails-assets-basscss'
  gem 'rails-assets-animate.css'
  gem 'rails-assets-flux'
end
gem 'react-rails'

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
  gem 'faker'
end

group :test do
  gem 'webmock'
  gem 'vcr'
  gem 'shoulda-matchers', require: false
  gem 'codeclimate-test-reporter', require: nil
  gem 'capybara'
  gem 'rack_session_access'
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
