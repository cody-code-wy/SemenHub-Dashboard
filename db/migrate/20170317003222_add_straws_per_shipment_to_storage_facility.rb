class AddStrawsPerShipmentToStorageFacility < ActiveRecord::Migration[5.0]
  def change
    add_column :storage_facilities, :straws_per_shipment, :integer
  end
end
