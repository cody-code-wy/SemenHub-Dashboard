class Sku < ApplicationRecord
  belongs_to :animal
  belongs_to :storagefacility, class_name: 'StorageFacility'
  belongs_to :seller, class_name: 'User'

  has_many :inventory_transaction

  validates_presence_of :semen_type, :price_per_unit, :semen_count

  enum semen_type: ["Conventional", "Male Sexed", "Female Sexed"]
  enum semen_count: ["2.1", "5.0"]
end
