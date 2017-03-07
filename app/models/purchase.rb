class Purchase < ApplicationRecord
  belongs_to :user

  has_many :purchase_transactions
  has_many :inventory_transactions, through: :purchase_transactions
  has_many :skus, through: :inventory_transactions

  enum state: ["problem", "created", "invoiced", "paid", "preparing for shipment", "shipped", "delivered", "canceled", "refunded"]
end
