class Purchase < ApplicationRecord
  belongs_to :user

  has_many :purchase_transactions
  has_many :inventory_transactions, through: :purchase_transactions
  has_many :skus, through: :inventory_transactions
  has_many :storagefacilities, through: :skus

  enum state: ["problem", "created", "invoiced", "paid", "preparing for shipment", "shipped", "delivered", "canceled", "refunded"]

  def total
    inventory_transactions.reduce(0) do |sum,trans|
      sum + -(trans.quantity * trans.sku.price_per_unit)
    end
  end
end
