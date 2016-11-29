# spec/mailers/user_mailer_spec.rb
require "rails_helper"

describe UserMailer  do
  describe "invite" do
    context "headers" do
      it "renders the subject" do
        user = build(:user, token: "abc")

        mail = described_class.invite(user)

        expect(mail.subject).to eq I18n.t("user_mailer.invite.subject")
      end

      it "sends to the right email" do
        user = build(:user, token: "abc")

        mail = described_class.invite(user)

        expect(mail.to).to eq [user.email]
      end

      it "renders the from email" do
        user = build(:user, token: "abc")

        mail = described_class.invite(user)

        expect(mail.from).to eq ["from@example.com"]
      end
    end

    it "includes the correct url with the user's token" do
      user = build(:user, token: "abc")

      mail = described_class.invite(user)

      expect(mail.body.encoded).to include confirmation_url(token: user.token)
    end
  end
end