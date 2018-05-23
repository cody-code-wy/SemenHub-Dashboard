class RemovePurchaseTransactions < ActiveRecord::Migration[5.0]

  class InventoryTransaction < ApplicationRecord

  end

  class PurchaseTransaction < ApplicationRecord

  end

  def up
    add_column :inventory_transactions, :purchase_id, :integer
    add_foreign_key :inventory_transactions, :purchases
    PurchaseTransaction.all.each do |pt|
      @it = InventoryTransaction.find(pt.inventory_transaction_id)
      puts "Migrating Inventory Transaction #{@it.id}"
      @it.update(purchase_id: pt.purchase_id)
    end
    drop_table :purchase_transactions
  end

  def down
    # create purchase_transactions table
    create_table :purchase_transactions do |t|
      t.references :purchase, foreign_key: true
      t.integer :inventory_transaction_id
      t.timestamps
    end
    InventoryTransaction.where.not(purchase_id: nil).each do |it|
      puts "Migrating Purchase #{it.purchase_id}"
      @pt = PurchaseTransaction.create(purchase_id: it.purchase_id, inventory_transaction_id: it.id)
    end
    remove_foreign_key :inventory_transactions, :purchases
    remove_column :inventory_transactions, :purchase_id
  end
end
