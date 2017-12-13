require "rails_helper"
RSpec.feature "Users can edit existing posts" do

  let(:user) { FactoryGirl.create(:user) }

  before do
    login_as(user)
  end

  scenario "Premium user against own post" do
    premium=Role.where(name:"premium", description: "Paid. Create & Update public and private posts. Ability to collaborate.").first_or_create
    Assignment.where( user: user, role: premium).first_or_create
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

  scenario "Admin user against own post" do
    admin=Role.where(name:"admin", description: "Administrator. Do almost everything.").first_or_create
    Assignment.where( user: user, role: admin).first_or_create
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

  scenario "Standard user against public post " do
    premium=Role.where(name:"premium", description: "Paid. Create & Update public and private posts. Ability to collaborate.").first_or_create
    Assignment.where( user: user, role: premium).first_or_create
    visit "/"
    click_link "New Post"
    fill_in "Title", with: "Sublime Text 5"
    fill_in "Body", with: "A text editor for everyone"
    click_button "Create Post"
    expect(page).to have_content "Post has been created"

    click_link "Sign Out"
    expect(page).to have_content "Signed out successfully."
    visit "/"
    click_link "Sign In"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
    expect(page).to have_content "Signed in successfully."


  end


end
