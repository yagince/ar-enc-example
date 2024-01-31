require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ArEncExample
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

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.active_record.encryption.support_unencrypted_data = true
    config.active_record.encryption.store_key_references = true

    config.active_record.encryption.primary_key         = [ENV["AR_ENC_PRIMARY_KEY"]]
    config.active_record.encryption.deterministic_key   = [ENV["AR_ENC_DETERMINISTIC_KEY"]]
    config.active_record.encryption.key_derivation_salt = ENV["AR_ENC_KEY_DERIVATION_SALT"]
  end
end
