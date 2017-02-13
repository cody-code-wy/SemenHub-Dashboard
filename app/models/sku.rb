class Sku < ApplicationRecord
  belongs_to :animal
  belongs_to :storagefacility, class_name: 'StorageFacility'
  belongs_to :seller, class_name: 'User'

  has_many :inventory_transaction

  validates_presence_of :semen_type, :price_per_unit, :semen_count
end
