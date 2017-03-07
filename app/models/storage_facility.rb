class StorageFacility < ApplicationRecord
  belongs_to :address
  has_many :fees

  validates_presence_of :phone_number, :website, :storage_fee, :release_fee, :name
end
