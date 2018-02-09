class Shipment < ApplicationRecord
  enum shipping_provider: {
      'UPS': 0,
      'FedEx': 1
  }

  belongs_to :purchase, touch: true
  belongs_to :address
  belongs_to :origin_address, class_name: 'Address'

  validates :shipping_provider, presence: true
  validates :origin_name, presence: true
end
