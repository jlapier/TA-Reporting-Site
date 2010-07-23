Given /^I am logged in as "(.*)"$/ do |email|
  visit new_user_session_path
  fill_in('E-mail Address', :with => email)
  fill_in('Password', :with => 'adude-73')
  click_button('Log in')
end