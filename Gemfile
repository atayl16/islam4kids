source 'https://rubygems.org'

gem 'rails', '~> 8.0.3'

# Assets
gem 'importmap-rails'
gem 'propshaft'
gem 'tailwindcss-rails'

# Database & Cache
gem 'pg'
gem 'redis'

# Web Server & Hotwire
gem 'jbuilder'
gem 'puma', '>= 5.0'
gem 'stimulus-rails'
gem 'turbo-rails'

# Background Jobs & Cables
gem 'solid_cable'
gem 'solid_queue'

# File Uploads
gem 'active_storage_validations'
gem 'image_processing'

# Authentication
gem 'devise', '~> 4.9'

# Deployment
gem 'kamal', require: false
gem 'thruster', require: false

# Misc
gem 'bootsnap', require: false
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'

  # Code Quality & Security
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'overcommit', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rails-omakase', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end
