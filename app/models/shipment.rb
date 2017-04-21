class Shipment < ApplicationRecord
  belongs_to :purchase, touch: true
  belongs_to :address

  enum shipping_provider: {
    'UPS': 0,
    'FedEx': 1
  }

end
