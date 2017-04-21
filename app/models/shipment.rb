class Shipment < ApplicationRecord
  belongs_to :purchase, touch: true
  belongs_to :address
  belongs_to :origin_address, class_name: 'Address'

  enum shipping_provider: {
    'UPS': 0,
    'FedEx': 1
  }

end
