# Configure Mails
if ENV.has_key?('SMTP_SERVER')
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address              => ENV['SMTP_SERVER'],
    :port                 => ENV['SMTP_PORT'],
    :domain               => ENV['SMTP_DOMAIN'],
    :user_name            => ENV['SMTP_LOGIN'],
    :password             => ENV['SMTP_PASSWORD'],
    :authentication       => :plain,
    :enable_starttls_auto => true#false
  }
  ActionMailer::Base.config.content_type = "text/html"
  ActionMailer::Base.config.mailer = ENV['MAILER_FROM']
  #ActionMailer::Base.perform_deliveries = true #try to force sending in development
  ActionMailer::Base.raise_delivery_errors = true
end
