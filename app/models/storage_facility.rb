class StorageFacility < ApplicationRecord
  belongs_to :address
  has_many :fees

  enum shipping_provider: {
    'UPS': 0,
    'FedEx': 1
  }

  validates_presence_of :phone_number, :website, :name, :shipping_provider
  validates :email, presence: true, email: true
end
