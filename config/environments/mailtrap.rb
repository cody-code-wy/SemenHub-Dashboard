require 'rubygems' if RUBY_VERSION < '1.9'
require 'rest_client'
require 'json'

response = RestClient::Resource.new("https://mailtrap.io/api/v1/inboxes.json?api_token=#{ENV['MAILTRAP_API_TOKEN']}", ssl_version: "TLSv1").get

first_inbox = JSON.parse(response)[0]

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
:user_name => first_inbox['username'],
:password => first_inbox['password'],
:address => first_inbox['domain'],
:domain => first_inbox['domain'],
:port => first_inbox['smtp_ports'][0],
:authentication => :plain
}
