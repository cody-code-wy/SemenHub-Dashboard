puts 'Adding Test Users'
puts 'THIS SHOULD NOT SHOW IN PRODUCTION'

test_user = User.find_by_email("test@test.com")
test_user ||= FactoryBot.create(:user, email: 'test@test.com', password: 'password')
test_user.roles << Role.find_by_name(:superuser)

puts 'Added Test Users'
