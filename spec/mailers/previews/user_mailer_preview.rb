class UserMailerPreview < ActionMailer::Preview

  def trip_confirmation
    UserMailer.trip_confirmation(trip)
  end

  def trip_information
    UserMailer.trip_information(trip)
  end

  def message_received_notification
    UserMailer.message_received_notification(message)
  end

  def message_sent_notification
    UserMailer.message_sent_notification(message)
  end

  private

  def trip
    Trip.last
  end

  def message
    Message.last
  end

end
