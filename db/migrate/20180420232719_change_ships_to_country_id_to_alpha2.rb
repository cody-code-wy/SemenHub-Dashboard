class ChangeShipsToCountryIdToAlpha2 < ActiveRecord::Migration[5.0]
  def up
    remove_foreign_key :ships_tos, :inventory_transactions
    remove_column :ships_tos, :country_id
    add_column :ships_tos, :alpha_2, :text
    add_index :ships_tos, :alpha_2
  end

  def down
    add_column :ships_tos, :country_id, :integer
    remove_column :ships_tos, :alpha_2
  end

end
