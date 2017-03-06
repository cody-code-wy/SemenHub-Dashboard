class InventoryTransaction < ApplicationRecord
 has_many :purchase_transactions
  has_many :purchases, through: :purchase_transactions

  belongs_to :sku

  has_many :shipsTo, foreign_key: 'inventoryTransaction_id'
  has_many :countries, through: :shipsTo
  

  validates_presence_of :quantity
end
