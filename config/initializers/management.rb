# frozen_string_literal: true

Rails.env.on(:development) do
  require 'rack-mini-profiler'
  Rack::MiniProfilerRails.initialize!(Rails.application)

  config.public_file_server.enabled = true

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = {
    host: "http://#{Rails.configuration.x.app_url}:#{Rails.configuration.x.default_port}"
  }
  config.action_mailer.smtp_settings = {
    address: Rails.configuration.x.default_smtp_address,
    port: Rails.configuration.x.default_smtp_port
  }
  config.action_cable.allowed_request_origins = [
    "http://#{Rails.configuration.x.app_url}:#{Rails.configuration.x.default_port}"
  ]
  config.action_cable.url = "ws://#{Rails.configuration.x.app_url}:#{Rails.configuration.x.default_port}/cable"

  Faker::Config.locale = 'pt'
end

Rails.env.on(:test) do
  config.active_job.queue_adapter = :test
  config.action_mailer.delivery_method = :test
  config.action_mailer.default_url_options = {
    host: "http://#{Rails.configuration.x.app_url}:#{Rails.configuration.x.default_port}"
  }
  config.action_cable.url = "ws://#{Rails.configuration.x.app_url}:#{Rails.configuration.x.default_port}/cable"
  Faker::Config.locale = 'pt'
end

Rails.env.on(:any) do
  config.time_zone = 'Brasilia'
  config.i18n.load_path += Dir["#{Rails.root}/config/locales/**/*.{rb,yml}"]
  config.i18n.available_locales = %i[en pt]
  config.i18n.default_locale = :pt
  config.i18n.fallbacks = %i[pt]

  config.active_job.queue_adapter = :sidekiq

  config.generators do |g|
    g.test_framework :rspec
    g.fixture_replacement :factory_bot, dir: 'spec/factories'
    g.helper_specs false
    g.controller_specs false
    g.view_specs false
    g.routing_specs false
    g.request_specs false
  end
end
