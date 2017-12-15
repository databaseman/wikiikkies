require "rails_helper"
RSpec.feature "Users viewing" do
  before do
    @premium=Role.create!(name:"premium", description: "Paid. Create & Update public and private posts. Ability to collaborate.")
    @admin=Role.create!(name:"admin", description: "Administrator. Do almost everything.")
  end

  scenario "List of users to delete" do
    premium_user = FactoryGirl.create(:user)
    Assignment.create!( user: premium_user, role: @premium)

    admin_user = FactoryGirl.create(:user)
    Assignment.create!( user: admin_user, role: @admin)
    login_as(admin_user)
    visit "/"
    click_link "Users"
    expect(page).to have_content premium_user.name+" ("+premium_user.email+")"
    expect(page).to have_link "Delete"
  end
end
