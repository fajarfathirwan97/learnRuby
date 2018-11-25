# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Role.where(:name => "Admin").destroy_all
role = Role.new
role.name = "Admin"
role.permission = "[\"*\"]"
role.save

user = User.new
user.first_name = "admin"
user.last_name = "admin"
user.phone = "123456789"
user.role_id = role.id
user.organisasi_id = ""
user.email = "admin@admin.com"
user.password = "password123"
user.encrypted_password = User.new(:password => params[:password]).encrypted_password
user.save
