# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "#{Rails.root}/db/country_seeds"
require "#{Rails.root}/db/registrar_seeds"
require "#{Rails.root}/db/role_permission_seeds"

case Rails.env
  when "test"
    test_user = User.find_by_email("test@test.com")
    test_user ||= FactoryBot.create(:user, email: 'test@test.com', password: 'password')
    test_user.roles << Role.find_by_name(:superuser)
end
