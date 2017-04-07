class AddDecimalLimiter < ActiveRecord::Migration[5.0]
  def change
    change_column :fees, :price, :decimal, precision: 30, scale: 2
    change_column :line_items, :value, :decimal, precision: 30, scale: 2
    change_column :skus, :price_per_unit, :decimal, precision: 30, scale: 2
    change_column :skus, :cost_per_unit, :decimal, precision: 30, scale: 2
  end
end
