require "rails_helper"
RSpec.feature "Users delete" do
  before do
    @premium=Role.create!(name:"premium", description: "Paid. Create & Update public and private posts. Ability to collaborate.")
    @admin=Role.create!(name:"admin", description: "Administrator. Do almost everything.")
  end

  scenario "Single user" do
    user = FactoryGirl.create(:user)
    Assignment.create!( user: user, role: @premium)

    admin_user = FactoryGirl.create(:user)
    Assignment.create!( user: admin_user, role: @admin)
    login_as(admin_user)
    visit "/users/index"
    expect(page).to have_content user.name+" ("+user.email+")"
    click_link "Delete"
    expect(page).to have_content "User #{user.name} #{user.email} has been deleted."
    click_link "Sign Out"
    expect(page).to have_content "Signed out successfully."

    visit "/"
    click_link "Sign In"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
    expect(page).to have_content "Invalid Email or password"
  end
end
