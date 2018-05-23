class InventoryTransaction < ApplicationRecord
  belongs_to :sku, touch: true
  belongs_to :purchase, touch: true, optional: true

  validates :quantity, presence: true
end
