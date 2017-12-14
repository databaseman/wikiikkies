require "rails_helper"
RSpec.feature "Users editing posts" do

  before do
    @user = FactoryGirl.create(:user)
    @premium=Role.create!(name:"premium", description: "Paid. Create & Update public and private posts. Ability to collaborate.")
    @admin=Role.create!(name:"admin", description: "Administrator. Do almost everything.")
    login_as(@user)
  end

  scenario "Premium user against own public post" do
    Assignment.create!( user: @user, role: @premium)
    visit "/"
    click_link "New Post"
    fill_in "Title", with: "Sublime Text 5"
    fill_in "Body", with: "A text editor for everyone"
    click_button "Create Post"
    expect(page).to have_content "Post has been created"

    click_link "Edit Post"
    fill_in "Title", with: "Sublime Text 4 beta"
    click_button "Update Post"

    post = Post.find_by(title: "Sublime Text 4 beta")
    expect(page.current_url).to eq post_url(post) # make sure this is Show action in post controller

    expect(page).to have_content "Post has been updated."
    expect(page).to have_content "Sublime Text 4 beta"
  end

  scenario "Premium user against another user private post " do
    Assignment.create!( user: @user, role: @premium)
    visit "/"
    click_link "New Post"
    fill_in "Title", with: "@Sublime Text 5"  #using @ to make sure it is on first page
    fill_in "Body", with: "A text editor for everyone"
    page.check "Private"
    click_button "Create Post"
    expect(page).to have_content "Post has been created"
    click_link "Sign Out"
    expect(page).to have_content "Signed out successfully."

    user = FactoryGirl.create(:user)
    login_as(user)
    Assignment.create!( user: user, role: @premium)
    visit "/"
    expect(page).to have_no_link('@Sublime Text 5')
  end

  scenario "Admin user against own public post" do
    Assignment.create!( user: @user, role: @admin)
    visit "/"
    click_link "New Post"
    fill_in "Title", with: "Sublime Text 5"
    fill_in "Body", with: "A text editor for everyone"
    click_button "Create Post"
    expect(page).to have_content "Post has been created"

    click_link "Edit Post"
    fill_in "Title", with: "Sublime Text 4 beta"
    click_button "Update Post"

    post = Post.find_by(title: "Sublime Text 4 beta")
    expect(page.current_url).to eq post_url(post) # make sure this is Show action in post controller

    expect(page).to have_content "Post has been updated."
    expect(page).to have_content "Sublime Text 4 beta"
  end

  scenario "Admin user against another user private post " do
    Assignment.create!( user: @user, role: @premium)
    visit "/"
    click_link "New Post"
    fill_in "Title", with: "@Sublime Text 5"  #using @ to make sure it is on first page
    fill_in "Body", with: "A text editor for everyone"
    page.check "Private"
    click_button "Create Post"
    expect(page).to have_content "Post has been created"
    click_link "Sign Out"
    expect(page).to have_content "Signed out successfully."

    user = FactoryGirl.create(:user)
    login_as(user)
    Assignment.create!( user: user, role: @admin)
    visit "/"
    expect(page).to have_link('@Sublime Text 5')
  end

  scenario "Standard user against public post " do
    Assignment.create!( user: @user, role: @premium)
    visit "/"
    click_link "New Post"
    fill_in "Title", with: "@Sublime Text 5"  #using @ to make sure it is on first page
    fill_in "Body", with: "A text editor for everyone"
    click_button "Create Post"
    expect(page).to have_content "Post has been created"
    click_link "Sign Out"
    expect(page).to have_content "Signed out successfully."

    user = FactoryGirl.create(:user)
    login_as(user)
    visit "/"
    click_link "@Sublime Text 5"
    click_link "Edit Post"
    fill_in "Title", with: "@Sublime Text 5B"
    click_button "Update Post"

    post = Post.find_by(title: "@Sublime Text 5B")
    expect(page.current_url).to eq post_url(post) # make sure this is Show action in post controller

    expect(page).to have_content "Post has been updated."
    expect(page).to have_content "@Sublime Text 5B"
  end

  scenario "Standard user against private post " do
    Assignment.create!( user: @user, role: @premium)
    visit "/"
    click_link "New Post"
    fill_in "Title", with: "@Sublime Text 5"  #using @ to make sure it is on first page
    fill_in "Body", with: "A text editor for everyone"
    page.check "Private"
    click_button "Create Post"
    expect(page).to have_content "Post has been created"
    click_link "Sign Out"
    expect(page).to have_content "Signed out successfully."

    user = FactoryGirl.create(:user)
    login_as(user)
    visit "/"
    expect(page).to have_no_link('@Sublime Text 5')
  end

end
