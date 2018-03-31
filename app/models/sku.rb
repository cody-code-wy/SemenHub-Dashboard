class Sku < ApplicationRecord
  enum semen_type: {
      'Conventional': 0,
      'Male Sexed': 1,
      'Female Sexed': 2
  }
  enum semen_count: {
      '2.1': 0,
      '5.0': 1,
      '4.0': 2
  }

  belongs_to :animal
  belongs_to :storagefacility, class_name: 'StorageFacility'
  belongs_to :seller, class_name: 'User'

  has_many :inventory_transaction

  validates :semen_type, presence: true
  validates :price_per_unit, presence: true
  validates :semen_count, presence: true

  #TODO refactor to be simpler
  def similar # get 'similar' skus, with least quantity first
    Sku.where(private: private, semen_type: semen_type, price_per_unit: price_per_unit, semen_count: semen_count, animal: animal, storagefacility: storagefacility).joins(:inventory_transaction).group(:id).order("sum(quantity) asc")
  end

  def quantity
    inventory_transaction.sum(:quantity)
  end

  def get_commission
    return seller.commission.commission_percent unless cost_per_unit
    (price_per_unit - cost_per_unit) / price_per_unit * 100
  end

  def get_cost_per_unit
    return cost_per_unit if cost_per_unit
    price_per_unit - (price_per_unit * (seller.commission.commission_percent / 100))
  end
end
