class AddShippingAdjustmentToStorageFacility < ActiveRecord::Migration[5.0]
  def change
    add_column :storage_facilities, :out_adjust, :integer
    add_column :storage_facilities, :in_adjust,  :integer
  end
end
