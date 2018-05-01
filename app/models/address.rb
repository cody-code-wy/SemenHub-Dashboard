class Address < ApplicationRecord
  belongs_to :country, foreign_key: 'alpha_2', primary_key: 'alpha_2'

  # validate :validate_address #this does not work well....
  validates :line1, presence: true
  validates :city, presence: true
  validates :region, presence: true
  validates :postal_code, presence: true

  def pretty_print
    "#{line1} \n#{line2}, \n#{city} #{region} \n#{postal_code}, \n#{country.name.upcase}"
  end

  def get_location
    "#{city}, #{region}"
  end

  def get_address_validator(name = "Resident")
    AddressValidator::Address.new(
      name: name,
      street1: line1,
      street2: line2,
      city: city,
      state: region,
      zip: postal_code,
      country: alpha_2
    )
  end

  def get_validator_response(name = "Resident")
    response ||= $validator.validate(get_address_validator(name))
    response
  end

  def is_valid_address(name = "Resident")
    get_validator_response(name).valid?
  end

  def validate_address
    errors.add(:address, "Address is invalid") unless is_valid_address
  end

  def get_shipping_location
    ActiveShipping::Location.new(
      country: alpha_2,
      state: region,
      city: city,
      zip: postal_code
    )
  end
end
