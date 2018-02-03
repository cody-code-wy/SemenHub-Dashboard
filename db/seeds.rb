# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "#{Rails.root}/db/country_seeds"

Registrar.find_or_create_by(breed: Breed.find_or_create_by(breed_name: "Longhorn"), address: Address.find_or_create_by(line1: "P.O. Box 4430", city: "Fort Worth", region: "Texas", alpha_2: 'us', postal_code: "76164"), name: "TLBAA", phone_primary: "817-625-6241", phone_secondary: "817-625-1388", website: "http://www.tlba.org", email: "tlbaa@tlbaa.org", note: "Secondary phone number is FAX")

Registrar.find_or_create_by(breed: Breed.find_or_create_by(breed_name: "Longhorn"), address: Address.find_or_create_by(line1: "P.O. Box 2610", city: "Gren Rose", region: "Texas", alpha_2: 'us', postal_code: "76043"), name: "ITLA", phone_primary: "254-898-0157", website: "http://www.itla.com", email: "staff@itla.com")

Registrar.find_or_create_by(breed: Breed.find_or_create_by(breed_name: "Longhorn"), address: Address.find_or_create_by(line1: "P.O. Box PLACEHOLDER", city: "Place Holder", region: "Texas", alpha_2: 'us', postal_code: "76032"), name: "TLCA", phone_primary: "780-362-4321", website: "http://holdplacer.space", email: "user@holdplacer.space")

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
