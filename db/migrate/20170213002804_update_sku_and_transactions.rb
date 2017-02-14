class UpdateSkuAndTransactions < ActiveRecord::Migration[5.0]

  class InventoryTransaction < ApplicationRecord

  end

  class Sku < ApplicationRecord

  end



  def up
   change_table :inventory_transactions do |t|
     t.references :sku, foreign_key: true;
   end

    @transactions = InventoryTransaction.all
    puts "Creating #{@transactions.count} skus"
    @transactions.each do |t|
      t.sku_id = Sku.find_or_create_by(t.attributes.except("created_at","updated_at","quantity","id","sku_id")).id
      t.save
    end
  [:private, :semen_type, :price_per_unit, :semen_count, :animal_id, :storagefacility_id, :seller_id, :cost_per_unit].each {|column| remove_column :inventory_transactions, column }
  end

  def down
    change_table :inventory_transactions do |t|
      t.boolean "private"
      t.integer "semen_type"
      t.decimal "price_per_unit"
      t.integer "semen_count"
      t.integer "seller_id"
      t.decimal "cost_per_unit"
      t.references :animal, foreign_key: true
      t.references :storagefacility, foreign_key: {to_table: :storage_facilities}
    end

    @transactions = InventoryTransaction.all
    puts "rolling back #{@transactions.count} inventory transactions"

    @transactions.each do |t|
      t.update(Sku.find(t.sku_id).attributes.except("id","created_at","updated_at"))
    end

    remove_column :inventory_transactions, :sku_id
  end

end
