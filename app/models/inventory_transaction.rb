class InventoryTransaction < ApplicationRecord
  belongs_to :sku, touch: true

  has_many :purchase_transactions
  has_many :purchases, through: :purchase_transactions

  validates :quantity, presence: true
end
