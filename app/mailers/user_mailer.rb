class UserMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def trip_confirmation(trip)
    @trip = trip
    mail(to: @trip.email, subject: '[Covoiturage-libre.fr] Validation de votre annonce')
  end

  def trip_information(trip)
    @trip = trip
    mail(to: @trip.email, subject: '[Covoiturage-libre.fr] Gestion de votre annonce')
  end

  def message_notification(message)
    @message = message
    @trip = message.trip
    mail(to: @trip.email, subject: '[Covoiturage Libre] Vous avez reçu un message pour votre annonce')
  end

end
