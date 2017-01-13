class Purchase < ApplicationRecord
  belongs_to :user

  has_many :purchaseTransactions
  has_many :inventoryTransactions, through: :purchaseTransactions
end
