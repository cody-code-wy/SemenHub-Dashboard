AddressValidator.configure do |config|
    config.key = ENV['UPS_KEY']
    config.username = ENV['UPS_USERNAME']
    config.password = ENV['UPS_PASSWORD']
    config.maximum_list_size = 5
end

$validator = AddressValidator::Validator.new
