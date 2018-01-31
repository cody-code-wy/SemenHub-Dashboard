class ChangeShipsToInventoryTransactionsToSku < ActiveRecord::Migration[5.0]
  def change
    rename_column :ships_tos, :inventoryTransaction_id, :sku_id
  end
end
