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
Collaborator.delete_all
TITLE_SIZE=70

# create roles.  No role / standard is the default
# Role.create!(name:"standard", description: "Free. Update public posts only.")
Role.create!(name:"premium", description: "Paid. Create & Update public and private posts. Ability to collaborate.")
Role.create!(name:"admin", description: "Administrator. Do almost everything.")

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

#####################################################################
#             Create Minh users
#####################################################################
name  = "minh"
email = "nguyen_ba_minh@yahoo.com"
password = "Password1"
User.create!(name:  name,
            email: email,
            password:              password,
            password_confirmation: password )

users = User.where( "email LIKE ?", 'nguyen_ba_minh%' )
role = Role.where( name: 'premium').first
users.each { |user| Assignment.create!( user: user, role: role) }

#
puts "Seed finished"
puts "#{Role.count} roles created"
puts "#{User.count} users created"
puts "#{Assignment.count} roles assigned"
puts "#{Post.count} posts created"
puts "#{Collaborator.count} collaborators created"
