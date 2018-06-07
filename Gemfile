source 'https://rubygems.org'
ruby '2.5.0'

# Dot Env for devel and test
gem 'dotenv-rails', groups: [:development, :test]
# RestClient gem for setup of SMTP services
gem 'rest-client'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0'
# Use posgresql as the database for Active Record
gem 'pg'
# Use Redis for in memory cart management
gem 'redis'
# Use hiredis for improved speed when working with redis
gem 'hiredis'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Use tablesorter
gem 'jquery-tablesorter'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# enable jsonp support for jbuilder
gem 'jpbuilder'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# UPS Street level address validator
gem 'address_validator', git: 'https://github.com/robhurring/address-validator'
# Use Active Shipping
gem 'active_shipping', '~> 2.1.1' # 2.2.0 and greater do not have UPS integration used in semenhub. Do not update until ready to integrate UPS's first party API
# Use Authorize.net
gem 'authorizenet'
# use Cookie-js
gem 'js_cookie_rails'
# use premalier css mailer awesome thing
gem 'premailer-rails'
# nokogiri... required by premailer
gem 'nokogiri'
# AWS-SDK for S3 images uploading
gem 'aws-sdk'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'database_cleaner'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'simplecov', require: false
  gem 'capybara'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
