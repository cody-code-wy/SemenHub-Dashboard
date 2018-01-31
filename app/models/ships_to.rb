class ShipsTo < ApplicationRecord
  belongs_to :country
  belongs_to :sku
end
