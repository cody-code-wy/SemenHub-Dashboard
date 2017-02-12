class CreateInventoryTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :inventory_transactions do |t|
      t.integer :quantity
      t.boolean :private
      t.integer :semen_type
      t.decimal :price_per_unit
      t.integer :semen_count
      t.references :animal, foreign_key: true
      t.references :storageFacility, foreign_key: {to_table: :storage_facilities}

      t.timestamps
    end
  end
end
