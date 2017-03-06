class Purchase < ApplicationRecord
  belongs_to :user

  has_many :purchase_transactions
  has_many :inventory_transactions, through: :purchase_transactions
end
