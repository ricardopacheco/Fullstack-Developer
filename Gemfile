# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'
gem 'pg', '1.4.5'
gem 'puma', '6.0.2'
gem 'rails', '7.0.4.2'

# Rails official Frontend tools
gem 'cssbundling-rails', '1.1.2'
gem 'jsbundling-rails', '1.1.1'
gem 'sprockets-rails', '3.4.2'

# Load app config by environment
gem 'rails-env', '2.0.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '1.16.0', require: false

# Toolkit for handling file attachments and dependencies
gem 'shrine', '3.4.0'
gem 'aws-sdk-s3', '1.119.0'
gem 'fastimage', '2.2.6'
gem 'image_processing', '1.12.2'
gem 'marcel', '1.0.2'

# Dry-rb gems
gem 'dry-rails', '0.7.0'
gem 'dry-monads', '1.6.0'
gem 'dry-matcher', '1.0.0'
gem 'dry-schema', '1.13.0'
gem 'dry-validation', '1.10.0'

# Authentication
gem 'devise', '4.8.1'

# DSL for form views
gem 'simple_form', '5.2.0'

# Import XLSX files
gem 'roo', '2.10.0'

# Background job processing
gem 'sidekiq'

# Frontend tool: Charts
gem 'chartkick', '5.0.1'

group :development do
  gem 'brakeman', '5.4.0'
  gem 'overcommit', '0.60.0'
  gem 'rack-mini-profiler', '3.0.0', require: false
  gem 'rubocop', '1.44.1', require: false
  gem 'rubocop-performance', '1.15.2', require: false
  gem 'rubocop-rails', '2.17.4', require: false
  gem 'rubocop-rspec', '2.18.1', require: false
  gem 'rubycritic', '4.7.0', require: false
end

group :development, :test do
  gem 'dotenv-rails', '2.8.1'
  gem 'faker', '3.1.0'
  gem 'ffaker', '2.21.0'
  gem 'pry-rails', '0.3.9'
  gem 'rspec-rails', '6.0.1'
end

group :test do
  gem 'capybara', '3.38.0'
  gem 'database_cleaner-active_record', '2.0.1'
  gem 'factory_bot_rails', '6.2.0'
  gem 'shoulda-matchers', '5.3.0'
  gem 'simplecov', '0.22.0', require: false
end
