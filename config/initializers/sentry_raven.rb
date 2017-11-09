if ENV.has_key? 'SENTRY_RAVEN_DSN'
  Raven.configure do |config|
    config.dsn = ENV.fetch('SENTRY_RAVEN_DSN')
    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  end
end
