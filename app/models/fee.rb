class Fee < ApplicationRecord
  enum fee_type: {
    'Release': 0,
    'Handling': 1,
    'Tank Rental': 2,
    'Packaging Fee': 3
  }

  belongs_to :storage_facility

  validates :price, presence: true
  validates :fee_type, presence: true
end
