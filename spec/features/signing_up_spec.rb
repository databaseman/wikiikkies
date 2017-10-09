require "rails_helper"
RSpec.feature "Users sign up" do
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

  scenario "when providing duplicate email" do
    visit "/"
    click_link "Sign up"
    fill_in "Name", with: "testuser1"
    fill_in "Email", with: "test@yahoo.com"
    fill_in "user_password", with: "Password1"
    fill_in "Password confirmation", with: "Password1"
    click_button "Sign up"
    expect(page).to have_content("You have signed up successfully.")

    click_link "Sign out"
    expect(page).to have_content "Signed out successfully."
    click_link "Sign up"
    fill_in "Name", with: "testuser1"
    fill_in "Email", with: "test@yahoo.com"
    fill_in "user_password", with: "Password1"
    fill_in "Password confirmation", with: "Password1"
    click_button "Sign up"
    expect(page).to have_content("Email has already been taken")
  end

  scenario "when providing invalid name" do
    visit "/"
    click_link "Sign up"
    fill_in "Name", with: ""
    fill_in "Email", with: "test@yahoo.com"
    fill_in "user_password", with: "Password1"
    fill_in "Password confirmation", with: "Password1"
    click_button "Sign up"
    expect(page).to have_content("can't be blank")
  end

  scenario "when providing invalid email" do
    visit "/"
    click_link "Sign up"
    fill_in "Name", with: "tests"
    fill_in "Email", with: "test@.com"
    fill_in "user_password", with: "Password1"
    fill_in "Password confirmation", with: "Password1"
    click_button "Sign up"
    expect(page).to have_content("is invalid")
  end

  scenario "when providing invalid password" do
    visit "/"
    click_link "Sign up"
    fill_in "Name", with: "tests"
    fill_in "Email", with: "test@yahoo.com"
    fill_in "user_password", with: "password1"
    fill_in "Password confirmation", with: "password1"
    click_button "Sign up"
    expect(page).to have_content("must contain big, small letters and digits")
    expect(page).to have_content("8 characters minimum")
  end

  scenario "when providing short password" do
    visit "/"
    click_link "Sign up"
    fill_in "Name", with: "tests"
    fill_in "Email", with: "test@yahoo.com"
    fill_in "user_password", with: "Pasw0rd"
    fill_in "Password confirmation", with: "Pasw0rd"
    click_button "Sign up"
    expect(page).to have_content("8 characters minimum")
  end



end
