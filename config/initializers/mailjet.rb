# initializers/mailjet.rb
if ENV.has_key?('MAILJET_API_KEY') && ENV.has_key?('MAILJET_API_SECRET')
  Mailjet.configure do |config|
    config.api_key = ENV.fetch('MAILJET_API_KEY')
    config.secret_key = ENV.fetch('MAILJET_API_SECRET')

    mail_host = Rails.application.config.action_mailer.default_url_options[:host]
    domain = URI.parse(mail_host).domain rescue 'covoiturage-libre.fr'
    config.default_from = "noreply@#{domain}"
  end
end
