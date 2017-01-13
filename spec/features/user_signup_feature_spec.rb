require 'rails_helper'

describe 'account creation' do

  before(:each) { sign_up(subdomain) }

  it 'allows user to create account' do
    expect(page.current_url).to include(subdomain)
    expect(Account.all.count).to eq(1)
  end

  it 'allows access of subdomain' do
    # we can't test the flash because it won't work as we are redirected to a subdomain
    visit root_url(subdomain: subdomain)
    expect(page.current_url).to include(subdomain)
  end

  it 'allows account followup creation' do
    subdomain2 = FactoryGirl.generate(:subdomain)
    sign_up_when_logged_in(subdomain2)
    expect(page.current_url).to include(subdomain2)
    expect(Account.all.count).to eq(2)
  end

  it 'does not allow account creation on subdomain' do
    user = User.first
    subdomain = Account.first.subdomain
    expect { visit new_account_url(subdomain: subdomain) }.to raise_error ActionController::RoutingError
  end

  it 'account owner has admin role for his new created account' do
    user = User.first
    account = Account.first
    account.memberships.find_by(user: user).has_role?(:admin)
  end

  def sign_up(subdomain)
		owner = FactoryGirl.attributes_for(:user)

    visit root_path
    click_link 'new_account'

    fill_in 'account[owner_attributes][first_name]', with: owner[:first_name]
    fill_in 'account[owner_attributes][last_name]', with: owner[:last_name]
    fill_in 'account[owner_attributes][email]', with: owner[:email]
    fill_in 'account[owner_attributes][password]', with: owner[:password]
    fill_in 'account[owner_attributes][password_confirmation]', with: owner[:password]
    fill_in 'account[subdomain]', with: subdomain
    click_button 'create_account'
  end

  def sign_up_when_logged_in(subdomain)
    #owner = FactoryGirl.attributes_for(:user)

    visit root_path(subdomain: false)
    click_link 'new_account'

    fill_in 'account[subdomain]', with: subdomain
    click_button 'create_account'
  end

end
