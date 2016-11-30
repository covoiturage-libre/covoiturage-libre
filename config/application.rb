require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CovoiturageLibreRails5
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.action_mailer.default_url_options = { host: ENV['MAILER_HOST'] }

    config.assets.paths << Rails.root.join("vendor", "assets", "images")
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif *.svg)

    config.generators do |g|
      g.test_framework :rspec
    end

    # Add this line to config/application.rb. This tells Rails to serve error pages from the Rails app itself
    # (i.e. the routes we just set up), rather than using static error pages in public/.
    config.exceptions_app = self.routes

  end
end
