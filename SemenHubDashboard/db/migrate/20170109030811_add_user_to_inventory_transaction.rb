class AddUserToInventoryTransaction < ActiveRecord::Migration[5.0]
  def change
    add_column :inventory_transactions, :seller_id, :integer
  end
end
