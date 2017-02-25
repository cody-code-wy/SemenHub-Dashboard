class Fee < ApplicationRecord
  belongs_to :storage_facility
  
  enum fee_type: {
    release: 0,
    handeling: 1,
    tank_rental: 2,
    packaging_fee: 3
  }

  validates_presence_of :price, :fee_type

end
