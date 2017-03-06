def sign_user_in(user, password: user.password)
  visit new_user_session_path

  fill_in 'user[email]', with: user.email
  fill_in 'user[password]', with: password
  click_button 'sign_in'
end

def fill_autocomplete(field, options = {})
  fill_in field, with: options[:with]

  page.execute_script %Q{ $('##{field}').trigger('focus') }
  page.execute_script %Q{ $('##{field}').trigger('keydown') }
  selector = %Q{ul.ui-autocomplete li.ui-menu-item a:contains("#{options[:select]}")}

  page.should have_selector('ul.ui-autocomplete li.ui-menu-item a')
  page.execute_script %Q{ $('#{selector}').trigger('mouseenter').click() }
end