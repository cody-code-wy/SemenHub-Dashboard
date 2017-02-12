class CreateShipsTos < ActiveRecord::Migration[5.0]
  def change
    create_table :ships_tos do |t|
      t.references :country, foreign_key: true
      t.references :inventoryTransaction, foreign_key: {to_table: :inventory_transactions}

      t.timestamps
    end
  end
end
