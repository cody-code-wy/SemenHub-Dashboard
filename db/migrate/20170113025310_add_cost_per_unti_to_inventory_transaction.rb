class AddCostPerUntiToInventoryTransaction < ActiveRecord::Migration[5.0]
  def change
    add_column :inventory_transactions, :cost_per_unit, :decimal
  end
end
