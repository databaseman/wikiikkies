require "rails_helper"
RSpec.feature "Editing Role" do
  before do
    @user = FactoryGirl.create(:user)
    @admin=Role.create!(name:"admin", description: "Administrator. Do almost everything.")
    Assignment.create!( user: @user, role: @admin)
    login_as(@user)
    visit "/"
  end

  scenario "Admin user" do
    click_link "Roles"
    click_link "New Role"
    fill_in "role_name", with: "Standardtest"
    fill_in "role_description", with: "Free. Can only view/update public posts"
    click_button "Create Role"
    expect(page).to have_content "Role has been created"

    click_link "Roles"
    click_link "Standardtest"
    click_link "Edit Role"
    fill_in "role_description", with: "Updated description"
    click_button "Update Role"
    expect(page).to have_content "Role has been updated"
  end


end
