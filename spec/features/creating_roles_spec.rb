require "rails_helper"
RSpec.feature "Create new role" do

  before do
    @user = FactoryGirl.create(:user)
    @admin=Role.create!(name:"admin", description: "Administrator. Do almost everything.")
    Assignment.create!( user: @user, role: @admin)
    login_as(@user)
    visit "/"
  end

  scenario "with valid attributes" do
    click_link "Roles"
    click_link "New Role"

    fill_in "role_name", with: "Standardtest"
    fill_in "role_description", with: "Free. Can only view/update public posts"
    click_button "Create Role"
    expect(page).to have_content "Role has been created"
    expect(page.current_url).to eq admin_roles_url
  end

  scenario "when providing invalid attributes" do
    click_link "Roles"
    click_link "New Role"
    click_button "Create Role"
    expect(page).to have_content "Role has not been created."
    expect(page).to have_content "Name can't be blank"
  end

  scenario "when providing duplicate name" do
    click_link "Roles"
    click_link "New Role"
    fill_in "Name", with: "testrole"
    fill_in "Description", with: "testrole description"
    click_button "Create Role"
    expect(page).to have_content "Role has been created"

    click_link "New Role"
    fill_in "Name", with: "testrole"
    fill_in "Description", with: "testrole description"
    click_button "Create Role"
    expect(page).to have_content("Name has already been taken")
  end

end
