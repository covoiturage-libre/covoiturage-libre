class ApplicationMailer < ActionMailer::Base

  default from: ENV['MAILER_FROM'] || 'Covoiturage Libre <noreply@covoiturage-libre.fr>'
  layout 'mailer'

end
