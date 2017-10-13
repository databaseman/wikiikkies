require "rails_helper"
RSpec.feature "Users can view users" do
  scenario "with the user details" do
    user = FactoryGirl.create(:user) #email: will be passed to email in spec/factories/user_factory.rb
    visit "/users/index"
    click_link "#{user.email}"
    expect(page.current_url).to eq user_url(user)
  end
end
