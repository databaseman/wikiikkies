require "rails_helper"
RSpec.feature "Users sign up" do

  before do
    visit "/"
    click_link "Sign Up"
  end

  scenario "Create Standard user: when providing valid details" do
    fill_in "Name", with: "testuser1"
    fill_in "Email", with: "test@yahoo.com"
    fill_in "user_password", with: "Password1"
    fill_in "Password confirmation", with: "Password1"
    click_button "Sign Up"
    expect(page).to have_content("You have signed up successfully.")
  end

  scenario "Create Standard user: when providing duplicate email" do
    fill_in "Name", with: "testuser1"
    fill_in "Email", with: "test@yahoo.com"
    fill_in "user_password", with: "Password1"
    fill_in "Password confirmation", with: "Password1"
    click_button "Sign Up"
    expect(page).to have_content("You have signed up successfully.")

    click_link "Sign Out"
    expect(page).to have_content "Signed out successfully."
    click_link "Sign Up"
    fill_in "Name", with: "testuser1"
    fill_in "Email", with: "test@yahoo.com"
    fill_in "user_password", with: "Password1"
    fill_in "Password confirmation", with: "Password1"
    click_button "Sign Up"
    expect(page).to have_content("Email has already been taken")
  end

  scenario "Create Standard user: when providing invalid name" do
    fill_in "Name", with: ""
    fill_in "Email", with: "test@yahoo.com"
    fill_in "user_password", with: "Password1"
    fill_in "Password confirmation", with: "Password1"
    click_button "Sign Up"
    expect(page).to have_content("can't be blank")
  end

  scenario "Create Standard user: when providing invalid email" do
    fill_in "Name", with: "tests"
    fill_in "Email", with: "test@.com"
    fill_in "user_password", with: "Password1"
    fill_in "Password confirmation", with: "Password1"
    click_button "Sign Up"
    expect(page).to have_content("is invalid")
  end

  scenario "Create Standard user: when providing invalid password" do
    fill_in "Name", with: "tests"
    fill_in "Email", with: "test@yahoo.com"
    fill_in "user_password", with: "password1"
    fill_in "Password confirmation", with: "password1"
    click_button "Sign Up"
    expect(page).to have_content("must contain big, small letters and digits")
    expect(page).to have_content("8 characters minimum")
  end

  scenario "Create Standard user: when providing short password" do
    fill_in "Name", with: "tests"
    fill_in "Email", with: "test@yahoo.com"
    fill_in "user_password", with: "Pasw0rd"
    fill_in "Password confirmation", with: "Pasw0rd"
    click_button "Sign Up"
    expect(page).to have_content("8 characters minimum")
  end

end
