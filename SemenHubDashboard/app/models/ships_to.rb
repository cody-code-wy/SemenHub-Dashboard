class ShipsTo < ApplicationRecord
  belongs_to :country
  belongs_to :inventoryTransaction
end
