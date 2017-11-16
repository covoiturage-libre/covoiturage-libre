class UserMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  SUBJECT_PREFIX = ENV['MAILER_SUBJECT_PREFIX'] || '[Covoiturage-libre.fr]'

  def trip_confirmation(trip)
    @trip = trip
    mail(
      to: @trip.email,
      subject: prefix_subject('Validation de votre annonce')
     )
  end

  def trip_information(trip)
    return if ENV.has_key?('TRIP_INFORMATION_TIME_LIMIT') &&
                !trip.last_trip_information_at.nil? &&
                trip.last_trip_information_at >= (Time.now - ENV.fetch('TRIP_INFORMATION_TIME_LIMIT').to_i.seconds)

    @trip = trip
    mail(
      to: @trip.email,
      subject: prefix_subject('Gestion de votre annonce')
     )
    trip.update_attribute(:last_trip_information_at, Time.now)
  end

  def message_received_notification(message)
    @message = message
    @trip = message.trip
    mail(
      to: @trip.email,
      reply_to: @message.sender_email,
      subject: prefix_subject('Vous avez reçu un message')
    )
  end

  def message_sent_notification(message)
    @message = message
    @trip = message.trip
    mail(
      to: @message.sender_email,
      reply_to: @trip.email,
      subject: prefix_subject('Vous avez envoyé un message')
    )
  end

  private

  def prefix_subject(subject)
    "#{SUBJECT_PREFIX} #{subject}"
  end

end
