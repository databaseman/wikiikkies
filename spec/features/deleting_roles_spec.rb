require "rails_helper"
RSpec.feature "Users can delete roles" do
  scenario "successfully" do
    FactoryGirl.create(:role, name: "test_role")
    visit "/roles"
    click_link "test_role"
    click_link "Delete Role"
    expect(page).to have_content "Role has been deleted."
    expect(page.current_url).to eq roles_url
    expect(page).to have_no_content "test_role"
  end
end
