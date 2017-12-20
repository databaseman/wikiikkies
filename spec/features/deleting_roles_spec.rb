require "rails_helper"
RSpec.feature "Delete role" do
  before do
    @user = FactoryGirl.create(:user)
    @admin=Role.create!(name:"admin", description: "Administrator. Do almost everything.")
    Assignment.create!( user: @user, role: @admin)
    login_as(@user)
    visit "/"
  end

  scenario "with assigned users" do
    click_link "Roles"
    click_link "admin"
    click_link "Delete Role"
    expect(page).to have_content "Can not remove role"
  end

  scenario "with no assigned users" do
    click_link "Roles"
    click_link "New Role"

    fill_in "role_name", with: "testrole"
    fill_in "role_description", with: "Free. Can only view/update public posts"
    click_button "Create Role"
    expect(page).to have_content "Role has been created"

    click_link "testrole"
    click_link "Delete Role"
    expect(page).to have_content "Role has been deleted"
    expect(page.current_url).to eq admin_roles_url
  end

end
