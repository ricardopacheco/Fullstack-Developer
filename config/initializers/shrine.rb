# frozen_string_literal: true

SHRINE_I18N_SCOPE = 'shrine.errors.file'
GLOBAL_MAX_UPLOAD_FILE_SIZE = 20 * 1024 * 1024 # 20 MB

Rails.env.on(:development) do
  require 'shrine/storage/s3'

  s3_options = {
    access_key_id: Rails.configuration.x.s3_access_key_id,
    secret_access_key: Rails.configuration.x.s3_access_key_secret,
    endpoint: Rails.configuration.x.s3_endpoint,
    bucket: Rails.configuration.x.s3_bucket,
    region: Rails.configuration.x.s3_region,
    force_path_style: true
  }

  Shrine.storages = {
    cache: Shrine::Storage::S3.new(public: true, upload_options: { acl: 'public-read' }, prefix: 'cache', **s3_options),
    store: Shrine::Storage::S3.new(public: true, upload_options: { acl: 'public-read' }, prefix: 'store', **s3_options)
  }
end

Rails.env.on(:test) do
  require 'shrine/storage/memory'

  Shrine.storages = {
    cache: Shrine::Storage::Memory.new,
    store: Shrine::Storage::Memory.new
  }
end

Rails.env.on(:any) do
  require 'image_processing/mini_magick'

  Shrine.plugin :activerecord
  Shrine.plugin :derivatives, create_on_promote: true
  Shrine.plugin :determine_mime_type, analyzer: :marcel
  Shrine.plugin :cached_attachment_data
  Shrine.plugin :default_url, host: Rails.configuration.x.default_asset_host
  Shrine.plugin :instrumentation
  Shrine.plugin :pretty_location
  Shrine.plugin :remove_attachment
  Shrine.plugin :restore_cached_data
  Shrine.plugin :remote_url, max_size: GLOBAL_MAX_UPLOAD_FILE_SIZE
  Shrine.plugin :store_dimensions
  Shrine.plugin :upload_endpoint, max_size: GLOBAL_MAX_UPLOAD_FILE_SIZE
  Shrine.plugin :url_options, host: Rails.configuration.x.default_asset_host, store: { public: true }
  Shrine.plugin :validation_helpers, default_messages: {
    max_size: ->(max) { I18n.t(:max_size, max: max, scope: SHRINE_I18N_SCOPE) },
    min_size: ->(min) { I18n.t(:min_size, min: min, scope: SHRINE_I18N_SCOPE) },
    max_width: ->(max) { I18n.t(:max_width, max: max, scope: SHRINE_I18N_SCOPE) },
    min_width: ->(min) { I18n.t(:min_width, min: min, scope: SHRINE_I18N_SCOPE) },
    max_height: ->(max) { I18n.t(:max_height, max: max, scope: SHRINE_I18N_SCOPE) },
    min_height: ->(min) { I18n.t(:min_height, min: min, scope: SHRINE_I18N_SCOPE) },
    max_dimensions: ->(dims) { I18n.t(:max_dimensions, dims: dims, scope: SHRINE_I18N_SCOPE) },
    min_dimensions: ->(dims) { I18n.t(:min_dimensions, dims: dims, scope: SHRINE_I18N_SCOPE) },
    mime_type_inclusion: ->(list) { I18n.t(:mime_type_inclusion, list: list, scope: SHRINE_I18N_SCOPE) },
    mime_type_exclusion: ->(list) { I18n.t(:mime_type_exclusion, list: list, scope: SHRINE_I18N_SCOPE) },
    extension_inclusion: ->(list) { I18n.t(:extension_inclusion, list: list, scope: SHRINE_I18N_SCOPE) },
    extension_exclusion: ->(list) { I18n.t(:extension_exclusion, list: list, scope: SHRINE_I18N_SCOPE) }
  }
end
