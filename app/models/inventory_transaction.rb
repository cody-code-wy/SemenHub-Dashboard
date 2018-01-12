class InventoryTransaction < ApplicationRecord
 has_many :purchase_transactions
  has_many :purchases, through: :purchase_transactions

  belongs_to :sku, touch: true

  validates_presence_of :quantity
end
