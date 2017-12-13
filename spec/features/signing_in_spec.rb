require "rails_helper"
RSpec.feature "Users sign in" do
  let!(:user) { FactoryGirl.create(:user) }

  before do
    visit "/"
    click_link "Sign In"
  end

  scenario "Premium user with valid credentials" do
    premium=Role.where(name:"premium", description: "Paid. Create & Update public and private posts. Ability to collaborate.").first_or_create
    Assignment.where( user: user, role: premium).first_or_create
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
    expect(page).to have_content "Signed in successfully."
    expect(page).to have_content "#{user.name} (#{user.email})"
    expect(page).to have_link('New Post')
    expect(page).to have_link('Sign Out')
    expect(page).to have_link('Account')
    expect(page).to have_link('Profile')
    expect(page).to have_link('Downgrade')
    expect(page).to have_link('Cancel Account')
    expect(page).to have_link('About')
    expect(page).to have_link('Contact')
    expect(page).to have_link('Help')
  end

  scenario "Premium user with invalid email" do
    fill_in "Email", with: "test@.com"
    fill_in "user_password", with: user.password
    click_button "Sign in"
    expect(page).to have_content("Invalid Email or password.")
  end

  scenario "Premium user with invalid password" do
    fill_in "Email", with: user.email
    fill_in "user_password", with: "somepassword"
    click_button "Sign in"
    expect(page).to have_content("Invalid Email or password.")
  end

  scenario "Admin user with valid credentials" do
    admin=Role.where(name:"admin", description: "Administrator. Do almost everything.").first_or_create
    Assignment.where( user: user, role: admin).first_or_create
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
    expect(page).to have_content "Signed in successfully."
    expect(page).to have_content "#{user.name} (#{user.email})"
    expect(page).to have_link('New Post')
    expect(page).to have_link('Sign Out')
    expect(page).to have_link('Account')
    expect(page).to have_link('Profile')
    expect(page).to have_link('Users')
    expect(page).to have_link('Roles')
    expect(page).to have_link('About')
    expect(page).to have_link('Contact')
    expect(page).to have_link('Help')
  end

  scenario "Standard user with valid credentials" do
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
    expect(page).to have_no_link('New Post')
    expect(page).to have_link('Sign Out')
    expect(page).to have_link('Account')
    expect(page).to have_link('Profile')
    expect(page).to have_link('Upgrade')
    expect(page).to have_link('Cancel Account')
    expect(page).to have_link('About')
    expect(page).to have_link('Contact')
    expect(page).to have_link('Help')
  end

end
