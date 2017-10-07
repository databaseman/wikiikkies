require "rails_helper"
RSpec.feature "Users can edit existing roles" do
  before do
    FactoryGirl.create(:role, name: "Sublime Text 3")
    visit "/roles"
    click_link "Sublime Text 3"
    click_link "Edit Role"
  end

  scenario "with valid attributes" do
    fill_in "Name", with: "Sublime Text 4 beta"
    click_button "Update Role"

    expect(page).to have_content "Role has been updated."
    expect(page).to have_content "Sublime Text 4 beta"
  end

  scenario "when providing invalid attributes" do
    fill_in "Name", with: ""
    click_button "Update Role"
    expect(page).to have_content "Role has not been updated."
  end

end
