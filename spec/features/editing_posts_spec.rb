require "rails_helper"
RSpec.feature "Users can edit existing posts" do
  before do
    FactoryGirl.create(:post, title: "Sublime Text 3")
    visit "/"
    click_link "Sublime Text 3"
    click_link "Edit Post"
  end

  scenario "with valid attributes" do
    fill_in "Title", with: "Sublime Text 4 beta"
    click_button "Update Post"

    expect(page).to have_content "Post has been updated."
    expect(page).to have_content "Sublime Text 4 beta"
  end

  scenario "when providing invalid attributes" do
    fill_in "Title", with: ""
    click_button "Update Post"
    expect(page).to have_content "Post has not been updated."
  end

end
