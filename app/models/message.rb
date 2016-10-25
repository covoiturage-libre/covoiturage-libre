class Message < ApplicationRecord

  belongs_to :trip

  validates_presence_of :trip, :sender_name, :sender_email, :body

  after_create :send_notification_email

  private

    def send_notification_email
      UserMailer.message_notification(self).deliver_later
    end

end
