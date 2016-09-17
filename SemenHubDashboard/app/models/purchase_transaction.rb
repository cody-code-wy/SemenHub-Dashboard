class PurchaseTransaction < ApplicationRecord
  belongs_to :purchase
  belongs_to :inventoryTransaction
end
