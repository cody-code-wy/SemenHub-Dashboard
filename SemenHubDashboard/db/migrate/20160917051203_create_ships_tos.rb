class CreateShipsTos < ActiveRecord::Migration[5.0]
  def change
    create_table :ships_tos do |t|
      t.references :country, foreign_key: true
      t.references :inventoryTransaction, foreign_key: true

      t.timestamps
    end
  end
end
