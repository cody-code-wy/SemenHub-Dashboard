class ChangeStorageFacilityCase < ActiveRecord::Migration[5.0]
  def change
    rename_column :inventory_transactions, :storageFacility_id, :storagefacility_id
  end
end
