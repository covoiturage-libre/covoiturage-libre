class ApplicationMailer < ActionMailer::Base

  default from: ENV['MAILER_FROM'] ||
                  "#{Rails.application.config.app_name} <noreply@covoiturage-libre.fr>"
  layout 'mailer'

end
