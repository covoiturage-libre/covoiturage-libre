RouteTranslator.config do |config|
  config.force_locale = true
  config.hide_locale = true
  config.locale_param_key = :fr

  config.generate_unlocalized_routes = Rails.env.test?
end
