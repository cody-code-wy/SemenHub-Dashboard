class InventoryTransaction < ApplicationRecord
  belongs_to :animal
  belongs_to :storageFacility
  belongs_to :seller, class_name: 'User'

  has_many :purchaseTransactions, foreign_key: 'inventoryTransaction_id' # Rails generates FK as 'inventory_transaction_id' but the migration created 'inventoryTransaction_id'
  has_many :purchases, through: :purchaseTransactions

  has_many :shipsTo, foreign_key: 'inventoryTransaction_id'
  has_many :countries, through: :shipsTo
  
  validates_presence_of :quantity, :semen_type, :price_per_unit, :semen_count

end
