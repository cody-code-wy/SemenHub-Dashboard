class PurchaseTransaction < ApplicationRecord
  belongs_to :purchase
  belongs_to :inventory_transaction
end
