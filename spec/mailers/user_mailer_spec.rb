# spec/mailers/user_mailer_spec.rb
require "rails_helper"

describe UserMailer  do

  describe "trip_information" do
    it "should not resend trip_information during TRIP_INFORMATION_TIME_LIMIT" do
      trip = create(:trip)
      expect(described_class.trip_information(trip).deliver_now).to_not be_nil
      expect(described_class.trip_information(trip.reload, trip_information_time_limit: 30.minutes.to_s).deliver_now).to be_nil
    end
  end

  describe "invite" do
    skip "DEPRECATED" do
      context "headers" do
        it "renders the subject" do
          user = build(:user)

          mail = described_class.invite(user)

          expect(mail.subject).to eq I18n.t("user_mailer.invite.subject")
        end

        it "sends to the right email" do
          user = build(:user)

          mail = described_class.invite(user)

          expect(mail.to).to eq [user.email]
        end

        it "renders the from email" do
          user = build(:user)

          mail = described_class.invite(user)

          expect(mail.from).to eq ["from@example.com"]
        end
      end

      it "includes the correct url with the user's token" do
        user = build(:user)

        mail = described_class.invite(user)

        expect(mail.body.encoded).to include confirmation_url(token: user.token)
      end
    end
  end
end
