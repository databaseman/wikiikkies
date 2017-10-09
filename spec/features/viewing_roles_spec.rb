require "rails_helper"
RSpec.feature "Users can view roles" do
  scenario "with the view details" do
    role = FactoryGirl.create(:role, name: "Sublime Text 3") #title: will be passed to title in spec/factories/role_factory.rb
    visit "/roles"
    click_link "Sublime Text 3"
    expect(page.current_url).to eq role_url(role)
  end
end
