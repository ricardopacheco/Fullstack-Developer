# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
# require "active_storage/engine"
require 'action_controller/railtie'
require 'action_mailer/railtie'
# require "action_mailbox/engine"
# require "action_text/engine"
require 'action_view/railtie'
require 'action_cable/engine'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Management
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Custom global configurations
    config.secret_key_base = ENV.fetch('SECRET_KEY_BASE')
    config.x.environment = ENV.fetch('RAILS_ENV')
    config.x.database_url = ENV.fetch('DATABASE_URL')
    config.x.rails_serve_static_files = ENV.fetch('RAILS_SERVE_STATIC_FILES')
    config.x.ci = ENV.fetch('CI')
    config.x.rails_log_to_stdout = ENV.fetch('RAILS_LOG_TO_STDOUT')
    config.x.default_port = ENV.fetch('PORT')
    config.x.pidfile = ENV.fetch('PIDFILE')
    config.x.s3_access_key_id = ENV.fetch('S3_ACCESS_KEY')
    config.x.s3_access_key_secret = ENV.fetch('S3_ACCESS_KEY_SECRET')
    config.x.s3_endpoint = ENV.fetch('S3_ENDPOINT')
    config.x.s3_bucket = ENV.fetch('S3_BUCKET')
    config.x.s3_region = ENV.fetch('S3_REGION')
    config.x.min_password_length = ENV.fetch('MIN_PASSWORD_LENGTH').to_i
    config.x.max_password_length = ENV.fetch('MAX_PASSWORD_LENGTH').to_i
    config.x.default_smtp_port = ENV.fetch('SMTP_PORT').to_i
    config.x.default_smtp_address = ENV.fetch('SMTP_ADDRESS')
  end
end
