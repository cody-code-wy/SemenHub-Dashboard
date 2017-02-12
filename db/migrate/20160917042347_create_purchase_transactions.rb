class CreatePurchaseTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :purchase_transactions do |t|
      t.references :purchase, foreign_key: true
      t.references :inventoryTransaction, foreign_key: {to_table: :inventory_transactions}

      t.timestamps
    end
  end
end
