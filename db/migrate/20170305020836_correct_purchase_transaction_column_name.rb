class CorrectPurchaseTransactionColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :purchase_transactions, :inventoryTransaction_id, :inventory_transaction_id
  end
end
