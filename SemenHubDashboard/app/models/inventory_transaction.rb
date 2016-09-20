class InventoryTransaction < ApplicationRecord
  belongs_to :animal
  belongs_to :storageFacility

  has_many :purchaseTransactions, foreign_key: 'inventoryTransaction_id' # Rails generates FK as 'inventory_transaction_id' but the migration created 'inventoryTransaction_id'
  has_many :purchases, through: :purchaseTransactions

  has_many :shipsTo, foreign_key: 'inventoryTransaction_id'
  has_many :countries, through: :shipsTo
end
