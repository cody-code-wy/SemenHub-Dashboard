class Sku < ApplicationRecord
  belongs_to :animal
  belongs_to :storagefacility, class_name: 'StorageFacility'
  belongs_to :seller, class_name: 'User'

  has_many :inventory_transaction

  validates_presence_of :semen_type, :price_per_unit, :semen_count, :cane_code

  enum semen_type: ["Conventional", "Male Sexed", "Female Sexed"]
  enum semen_count: ["2.1", "5.0"]

  def similar # get 'similar' skus, with least quantity first
    Sku.where(private: private, semen_type: semen_type, price_per_unit: price_per_unit, semen_count: semen_count, animal: animal, storagefacility: storagefacility).joins(:inventory_transaction).group(:id).order("sum(quantity) asc")
  end

  def quantity
    inventory_transaction.sum(:quantity)
  end

end
