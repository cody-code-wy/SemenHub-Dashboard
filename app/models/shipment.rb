class Shipment < ApplicationRecord
  belongs_to :purchase, touch: true
  belongs_to :address
end
