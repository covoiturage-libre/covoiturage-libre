def sign_user_in(user, subdomain: nil, password: user.password)
  if subdomain
    visit new_user_session_ur
  else
    visit new_user_session_path
  end

  fill_in 'user[email]', with: user.email
  fill_in 'user[password]', with: password
  click_button 'sign_in'
end
