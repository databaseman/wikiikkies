require "rails_helper"
RSpec.feature "Users can view posts" do
  scenario "with the post details" do
    post = FactoryGirl.create(:post, title: "Sublime Text 3") #title: will be passed to title in spec/factories/post_factory.rb
    visit "/"
    click_link "Sublime Text 3"
    expect(page.current_url).to eq post_url(post)
  end
end
