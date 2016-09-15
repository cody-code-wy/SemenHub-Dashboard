class CreateShipments < ActiveRecord::Migration[5.0]
  def change
    create_table :shipments do |t|
      t.references :purchase, foreign_key: true
      t.integer :method
      t.date :requested_date
      t.string :location_name
      t.string :account_name
      t.references :address, foreign_key: true

      t.timestamps
    end
  end
end
