# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "#{Rails.root}/db/country_seeds"
require "#{Rails.root}/db/registrar_seeds"

role = Role.find_by_name :superuser
perms = [Permission.find_or_create_by(name: "superuser", description: "All Permissions Granted")]
if role
  role.permissions.destroy_all
  role.permissions << perms
else
  Role.create(name: "superuser", permissions: perms)
end

role = Role.find_by_name :default
perms = [Permission.find_or_create_by(name: "login", description: "Allows user to login"), Permission.find_or_create_by(name: "purchase", description: "Allows user to purchase items"), Permission.find_or_create_by(name: :"use_purchases_controller", description: "Allows user to view their purchases (invoices and recipts)")]
if role
  role.permissions.destroy_all
  role.permissions << perms
else
  Role.create(name: "default", permissions: perms)
end

role = Role.find_by_name :seller
perms = [Permission.find_or_create_by(name: "addStock", description: "Allows user to register own transactions")]
if role
  role.permissions.destroy_all
  role.permissions << perms
else
  Role.create(name: "seller", permissions: perms )
end

case Rails.env
  when "test"
    test_user = User.find_by_email("test@test.com")
    test_user ||= FactoryBot.create(:user, email: 'test@test.com', password: 'password')
    test_user.roles << Role.find_by_name(:superuser)
end
