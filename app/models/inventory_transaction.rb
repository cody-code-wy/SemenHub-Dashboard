class InventoryTransaction < ApplicationRecord
 has_many :purchaseTransactions, foreign_key: 'inventoryTransaction_id' # Rails generates FK as 'inventory_transaction_id' but the migration created 'inventoryTransaction_id'
  has_many :purchases, through: :purchaseTransactions
  belongs_to :sku

  has_many :shipsTo, foreign_key: 'inventoryTransaction_id'
  has_many :countries, through: :shipsTo
  

  validates_presence_of :quantity
end
