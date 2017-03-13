class AddCustomPercentToSku < ActiveRecord::Migration[5.0]
  def change
    add_column :skus, :has_percent, :boolean
  end
end
