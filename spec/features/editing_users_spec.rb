require "rails_helper"
RSpec.feature "User edit" do
  before do
    @user = FactoryGirl.create(:user)
    login_as(@user)
    visit "/"
  end

  scenario "As regular user updating with valid email" do
    click_link "Profile"
    fill_in "user_email", with: "newemail@yahoo.com"
    fill_in "user_current_password", with: @user.password
    click_button "Update"
    expect(page).to have_content "Your account has been updated successfully"
  end

  scenario "As regular user updating with invalid email" do
    click_link "Profile"
    fill_in "user_email", with: "newemail@.com"
    fill_in "user_current_password", with: @user.password
    click_button "Update"
    expect(page).to have_content "Email is invalid"
  end

end
