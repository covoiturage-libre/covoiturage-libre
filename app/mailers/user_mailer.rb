class UserMailer < ApplicationMailer

  def trip_information(trip)
    @trip = trip
    mail(to: @trip.email, subject: '[Covoiturage Libre] Informations sur votre annonce')
  end

  def message_notification(message)
    @message = message
    @trip = message.trip
    mail(to: @trip.email, subject: '[Covoiturage Libre] Vous avez reçu un message pour votre annonce')
  end

end
