class AddCaneNumberToInventoryTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :skus, :cane_code, :string
  end
end
