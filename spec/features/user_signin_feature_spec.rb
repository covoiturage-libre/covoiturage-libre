require 'rails_helper'

describe 'user signin' do
  skip "DEPRECATED" do
    let(:user) { build(:user) }

    it 'allows signin with valid credentials' do
      sign_user_in(user)
      expect(page).to have_content I18n.t(:'devise.sessions.signed_in')
    end

    it 'does not allow signin with invalid credentials' do
      sign_user_in(user, subdomain: account.subdomain, password: 'wrong password!')
      expect(page).to have_content I18n.t(:'devise.failure.invalid')
    end

    it 'does not allow user to sign in on a subdomain he is not a member of'

    it 'allows to swich from one subdomain to another when logged in' do
      account2 = create(:account_with_schema, owner: user)

      sign_user_in(user, subdomain: account2.subdomain)
      expect(page).to have_content I18n.t(:'devise.sessions.signed_in')

      visit root_url(subdomain: account.subdomain)
      expect(page.current_url).to eq(root_url(subdomain: account.subdomain))
    end

    it 'allows user to sign out' do
      sign_user_in(user, subdomain: account.subdomain)

      click_link 'sign_out'
      expect(page).to have_content I18n.t(:'devise.sessions.signed_out')
    end

  end
end
