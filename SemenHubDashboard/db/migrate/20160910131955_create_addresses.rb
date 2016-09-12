class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :line1
      t.string :line2
      t.string :postal_code
      t.string :city
      t.string :region
      t.string :alpha_2, limit: 2
      t.timestamps

      t.belongs_to :country, foreign_key: :alpha_2, primary_key: :alpha_2
    end
  end
end
