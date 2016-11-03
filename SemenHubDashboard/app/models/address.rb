class Address < ApplicationRecord
  belongs_to :country, foreign_key: 'alpha_2', primary_key: 'alpha_2'

  validates_presence_of :line1, :city, :region, :postal_code
end
