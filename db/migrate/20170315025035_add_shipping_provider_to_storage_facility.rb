class AddShippingProviderToStorageFacility < ActiveRecord::Migration[5.0]
  def change
    add_column :storage_facilities, :shipping_provider, :int
  end
end
