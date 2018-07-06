require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Railtie.load

module CovoiturageLibreRails5
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.authentication_enabled = ENV['AUTHENTICATION_ENABLED'] == 'true'
    config.app_name = ENV['APP_NAME'] || "Covoiturage-Libre.fr"
    config.pricing = ENV['PRICING'] == "true"
    config.legacy = ENV['LEGACY'] == "true"

    host = ENV['MAILER_HOST'] || 'localhost:3000'
    config.action_mailer.default_url_options = { host: host }
    Rails.application.routes.default_url_options[:host] = host

    config.assets.paths << Rails.root.join("vendor", "assets", "images")
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif *.svg)

    config.generators do |g|
      g.test_framework :rspec
    end

  end
end
