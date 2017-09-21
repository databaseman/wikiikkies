require "rails_helper"
RSpec.feature "Users can delete posts" do
  scenario "successfully" do
    FactoryGirl.create(:post, title: "Sublime Text 3")
    visit "/"
    click_link "Sublime Text 3"
    click_link "Delete Post"
    expect(page).to have_content "Post has been deleted."
    expect(page.current_url).to eq posts_url
    expect(page).to have_no_content "Sublime Text 3"
  end
end
