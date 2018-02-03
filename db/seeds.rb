# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env == 'development'
  puts 'Do you want to clear database (y/n)'
  response = STDIN.gets.chomp
  if response == 'y'
    puts 'Clearing Database'
    require 'database_cleaner'
    DatabaseCleaner.clean_with(:truncation)
  else
    puts 'Database NOT Cleared'
  end
end

if Rails.env == 'test'
  require 'database_cleaner'
  DatabaseCleaner.clean_with(:truncation)
end

ActiveRecord::Base.transaction do
  require "#{Rails.root}/db/country_seeds"
  require "#{Rails.root}/db/registrar_seeds"
  require "#{Rails.root}/db/role_permission_seeds"

  case Rails.env
    when "test"
      require "#{Rails.root}/db/test_user_seeds"
      require "#{Rails.root}/db/test_seeds"
    when "development"
      require "#{Rails.root}/db/test_user_seeds"
      require "#{Rails.root}/db/dev_seeds"
  end
end
