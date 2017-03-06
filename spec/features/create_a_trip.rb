require 'rails_helper'

describe 'create a trip' do
  let(:user) { build(:user) }

  it 'allows to create a valid trip without user sign in' do
    visit root_url
    click_link 'new_trip_button'
    fill_autocomplete 'trip_points_attributes_0_city', with: 'lille'
    # clic on 'Créer votre annonce'
    # I receive the trip confirmation email
    # I clic on confirm this trip
    # I see my trip
    # I receive the trip information email
  end

  it 'allows to create a valid trip with user sign up' do
    # visit homepage
    # clic button 'Publier une annonce'
    # fill in the trip form
    # clic on the link 'Create an account'
    # see the signin-or-signup screen
    # clic on 'Créer un compte'
    # fill in the signup pop-up form
    # receive an account+trip confirmation email
    # clic on create
    # I clic on confirm this trip
    # I see my trip
    # I receive the manage-trip-with-account insctructions email
  end

  it 'allows to create a valid trip with user sign in' do
    # visit homepage
    # clic button 'Publier une annonce'
    # fill in the trip form
    # clic on the link "J'ai déjà un compte"
    # see the signin-or-signup screen
    # clic on 'Connection'
    # fill in the signin pop-up form
    # clic on create
    # I see my trip
  end

end
