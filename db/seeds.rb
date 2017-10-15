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


# create roles
Role.create!(name:"standard", description: "Free. Update public posts only.")
Role.create!(name:"premium", description: "Paid. Create & Update public and private posts. Ability to collaborate.")
Role.create!(name:"admin", description: "Administrator. Do almost everything.")

# create standard users
3.times do |n|
   name  = Faker::Name.name
   email = "standard#{n+1}@yahoo.com"
   password = "Password1"
   User.create!(name:  name,
                email: email,
                password:              password,
                password_confirmation: password )
end

users = User.where( "email LIKE ?", 'standard%' )
#using Lazy Loading. Nothing is loaded before you will call certain object or objects.
#As a matter of fact your query will return an Array of objects if you don't specify .first
#and you will get this error ActiveRecord::AssociationTypeMismatch: Role expected, got Role::ActiveRecord_Relation
role = Role.where( name: 'standard').first
users.each { |user| Assignment.create!( user: user, role: role) }

# create premium users
3.times do |n|
   name  = Faker::Name.name
   email = "premium#{n+1}@yahoo.com"
   password = "Password1"
   User.create!(name:  name,
                email: email,
                password:              password,
                password_confirmation: password )
end

users = User.where( "email LIKE ?", 'premium%' )
role = Role.where( name: 'premium').first
users.each { |user| Assignment.create!( user: user, role: role) }

# Create Admin users
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
puts "--- #{User.where("email LIKE ?", 'premium%').count} PREMIUM"
puts "--- #{User.where("email LIKE ?", 'standard%').count} STANDARD"
puts "--- #{User.where("email LIKE ?", 'admin%').count} ADMIN"
puts "#{Assignment.count} roles assigned"
