class Fee < ApplicationRecord
  belongs_to :storage_facility

  enum fee_type: {
    'Release': 0,
    'Handling': 1,
    'Tank Rental': 2,
    'Packaging Fee': 3
  }

  validates_presence_of :price, :fee_type

end
