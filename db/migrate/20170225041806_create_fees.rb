class CreateFees < ActiveRecord::Migration[5.0]
  def change
    create_table :fees do |t|
      t.decimal :price
      t.integer :fee_type
      t.references :storage_facility, foreign_key: {to_table: :storage_facilities}

      t.timestamps
    end
  end
end
