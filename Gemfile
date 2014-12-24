source 'https://rubygems.org'
ruby '2.1.3'

###############################################################################
# Default Stuff                                                               #
###############################################################################

gem 'rails', '4.1.6'

# Database.
gem 'pg'

# Webserver
gem 'unicorn'

# Logs
gem 'lograge'

###############################################################################
# Assets, Views & Routes                                                      #
###############################################################################

# CSS
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier',   '>= 1.3.0'
gem 'bourbon',    '~> 3.2.3'
gem 'neat',       '~> 1.5.1'

# JS
gem 'coffee-rails',             '~> 4.0.0'
gem 'active_model_serializers', '~> 0.9.0'
gem 'js-routes',                '~> 0.9.9'

# Views
gem 'haml-rails'

###############################################################################
# Environments                                                                #
###############################################################################

group :test, :development do
  gem 'dotenv-rails'
  gem 'byebug',   '~> 3.5.1'
end

group :test do
  gem 'rspec'
  gem 'fivemat'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'webmock', '~> 1.9.3'
  gem 'vcr',     '~> 2.9.3'
  gem 'faker',   '~> 1.4.3'
end

group :development do
  gem 'pry-rails'
  gem 'spring'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'annotate', '~> 2.6.5'
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
gem 'geokit-rails', '~> 2.0.1'
