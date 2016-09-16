class CreateStorageFacilities < ActiveRecord::Migration[5.0]
  def change
    create_table :storage_facilities do |t|
      t.string :phone_number
      t.string :website
      t.decimal :storage_fee
      t.decimal :release_fee
      t.references :address, foreign_key: true

      t.timestamps
    end
  end
end
