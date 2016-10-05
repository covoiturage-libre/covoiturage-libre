# config/initializers/locale.rb

I18n.enforce_available_locales = false

I18n.config.available_locales = [:fr]

# Where the I18n library should search for translation files
I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

# Set default locale to something other than :en
I18n.default_locale = :fr