class Message < ApplicationRecord

  belongs_to :trip

  validates_presence_of :trip, :sender_name, :sender_email, :body

  after_create :send_notification_email

  private

    def send_notification_email
      UserMailer.message_received_notification(self).deliver_later
      UserMailer.message_sent_notification(self).deliver_later
    end

end
