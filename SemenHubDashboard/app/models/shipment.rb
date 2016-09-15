class Shipment < ApplicationRecord
  belongs_to :purchase
  belongs_to :address
end
