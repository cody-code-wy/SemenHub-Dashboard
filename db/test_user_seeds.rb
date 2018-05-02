puts 'Adding Test Users'
puts 'THIS SHOULD NOT SHOW IN PRODUCTION'

admin_test_user = User.find_by_email("test@test.com")
admin_test_user ||= FactoryBot.create(:user, email: 'test@test.com', password: 'password')
admin_test_user.roles << Role.find_by_name(:superuser)

normal_test_user = User.find_by_email("user@test.com")
normal_test_user ||= FactoryBot.create(:user, email: 'user@test.com', password: 'password')
normal_test_user.roles << Role.find_by_name(:default)

puts 'Added Test Users'
