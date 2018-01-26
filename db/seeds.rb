# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Assignment.delete_all
Post.delete_all
User.delete_all
Role.delete_all
TITLE_SIZE=70
NUMBER_OF_USERS=100
NUMBER_OF_POSTS=10

# create roles.  No role / standard is the default
# Role.create!(name:"standard", description: "Free. Update public posts only.")
Role.create!(name:"premium", description: "Paid. Create & Update public and private posts. Ability to collaborate.")
Role.create!(name:"admin", description: "Administrator. Do almost everything.")

#####################################################################
#             Standard users
#User with no role assigned are standard users; so no need to assign any role
#####################################################################

NUMBER_OF_USERS.times do |n|
   name  = Faker::Name.name
   email = "standard#{n+1}@yahoo.com"
   password = "Password1"
   User.create!(name:  name,
                email: email,
                password:              password,
                password_confirmation: password )
end

# Standard user can't create post. These could be left over when downgrade from premium.
# When downgrade, user still have ability to edit and delete their own posts
users = User.where( "email LIKE ?", 'standard%' ).take(15)
4.times do
  users.each { |user| user.posts.create!(title: Faker::Lorem.sentence(1).slice(0,TITLE_SIZE), body: Faker::Lorem.sentence(5) ) }
end

#####################################################################
#           Premium users
#####################################################################

NUMBER_OF_USERS.times do |n|
   name  = Faker::Name.name
   email = "premium#{n+1}@yahoo.com"
   password = "Password1"
   User.create!(name:  name,
                email: email,
                password:              password,
                password_confirmation: password )
end

#using Lazy Loading. Nothing is loaded before you will call certain object or objects.
#As a matter of fact your query will return an Array of objects if you don't specify .first
#and you will get this error ActiveRecord::AssociationTypeMismatch: Role expected, got Role::ActiveRecord_Relation
#role = Role.where( name: 'premium').first
#users.each { |user| Assignment.create!( user: user, role: role) }
users = User.where( "email LIKE ?", 'premium%' )
role = Role.where( name: 'premium').first
users.each { |user| Assignment.create!( user: user, role: role) }

# Premium users Public Microposts
users = User.where( "email LIKE ?", 'premium%' ).take( NUMBER_OF_USERS )
NUMBER_OF_POSTS.times do
  users.each { |user| user.posts.create!(title: Faker::Lorem.sentence(1).slice(0,TITLE_SIZE), body: Faker::Lorem.sentence(5) ) }
end

# Premium users Private Microposts
users = User.where( "email LIKE ?", 'premium%' ).take( (NUMBER_OF_USERS * 0.45).round )
NUMBER_OF_POSTS.times do
  users.each { |user| user.posts.create!(title: Faker::Lorem.sentence(1).slice(0,TITLE_SIZE), body: Faker::Lorem.sentence(5), private: true ) }
end

# Premium users Collaboratorating on private posts belonging to other Premium users.
users = User.where( "email LIKE ?", 'premium%' ).take((NUMBER_OF_USERS * 0.10).round )
users.each do |user|
  post=Post.where.not( user: user, private: false).take(20)
  post.each { |post| Collaborator.create!( user: user, post: post ) }
end

# Standard users Collaboratorating on private posts belonging to other Premium users.
users = User.where( "email LIKE ?", 'standard%' ).take((NUMBER_OF_USERS * 0.10).round )
users.each do |user|
  post=Post.where.not( user: user, private: false).take(20)
  post.each { |post| Collaborator.create!( user: user, post: post ) }
end

#####################################################################
#             Create Admin users
#####################################################################
name  = "admin"
email = "admin@yahoo.com"
password = "Password1"
User.create!(name:  name,
            email: email,
            password:              password,
            password_confirmation: password )

users = User.where( "email LIKE ?", 'admin%' )
role = Role.where( name: 'admin').first
users.each { |user| Assignment.create!( user: user, role: role) }

#
puts "Seed finished"
puts "#{Role.count} roles created"
puts "#{User.count} users created"
puts "#{Assignment.count} roles assigned"
puts "#{Post.count} posts created"
puts "#{Collaborator.count} collaborators created"
