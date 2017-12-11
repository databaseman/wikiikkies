require "rails_helper"
RSpec.feature "Users sign in" do

  before do
    visit "/"
    click_link "Sign in"
  end

  let!(:user) { FactoryGirl.create(:user) }
  scenario "with valid credentials" do
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
    expect(page).to have_content "Signed in successfully."
    expect(page).to have_content "#{user.name} (#{user.email})"
  end

  scenario "when providing invalid email" do
    fill_in "Email", with: "test@.com"
    fill_in "user_password", with: user.password
    click_button "Sign in"
    expect(page).to have_content("Invalid Email or password.")
  end

  scenario "when providing invalid password" do
    fill_in "Email", with: user.email
    fill_in "user_password", with: "somepassword"
    click_button "Sign in"
    expect(page).to have_content("Invalid Email or password.")
  end

end
