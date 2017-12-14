require "rails_helper"
RSpec.feature "Users sign in" do
  before do
    @user = FactoryGirl.create(:user)
    @premium=Role.create!(name:"premium", description: "Paid. Create & Update public and private posts. Ability to collaborate.")
    @admin=Role.create!(name:"admin", description: "Administrator. Do almost everything.")
  end

  scenario "Premium user with valid credentials" do
    Assignment.create!( user: @user, role: @premium)
    visit "/"
    click_link "Sign In"
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_button "Sign in"
    expect(page).to have_content "Signed in successfully."
    expect(page).to have_content "#{@user.name} (#{@user.email})"
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

  scenario "User with invalid email" do
    visit "/"
    click_link "Sign In"
    fill_in "Email", with: "test@.com"
    fill_in "user_password", with: @user.password
    click_button "Sign in"
    expect(page).to have_content("Invalid Email or password.")
  end

  scenario "User with invalid password" do
    visit "/"
    click_link "Sign In"
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: "somepassword"
    click_button "Sign in"
    expect(page).to have_content("Invalid Email or password.")
  end

  scenario "Admin user with valid credentials" do
    Assignment.create!( user: @user, role: @admin)
    visit "/"
    click_link "Sign In"
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_button "Sign in"
    expect(page).to have_content "Signed in successfully."
    expect(page).to have_content "#{@user.name} (#{@user.email})"
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
    visit "/"
    click_link "Sign In"
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
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
