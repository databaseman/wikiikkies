require "rails_helper"
RSpec.feature "Users can sign up" do
  scenario "when providing valid details" do
    visit "/"
    click_link "Sign up"
    fill_in "Name", with: "testuser1"
    fill_in "Email", with: "test@yahoo.com"
    fill_in "user_password", with: "Password1"
    fill_in "Password confirmation", with: "Password1"
    click_button "Sign up"
    expect(page).to have_content("You have signed up successfully.")
  end
end
