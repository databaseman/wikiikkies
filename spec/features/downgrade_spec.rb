require "rails_helper"
RSpec.feature "User downgrade" do

  scenario "As Premium user with private post" do
    premium=Role.create!(name:"premium", description: "Paid. Create & Update public and private posts. Ability to collaborate.")
    user = FactoryGirl.create(:user)
    Assignment.create!( user: user, role: premium)
    login_as(user)
    visit "/"
    click_link "New Post"
    fill_in "Title", with: "Sublime Text 5"
    fill_in "Body", with: "A text editor for everyone"
    page.check "Private"
    click_button "Create Post"
    expect(page).to have_content "Post has been created"

    click_link "Downgrade"
    expect(page).to have_content "Downgrade Account"
    click_button "Downgrade"
    expect(page).to have_content "Your account has been downgraded"
  end

end
