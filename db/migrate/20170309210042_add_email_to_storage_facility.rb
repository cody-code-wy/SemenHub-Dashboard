class AddEmailToStorageFacility < ActiveRecord::Migration[5.0]
  def change
    add_column :storage_facilities, :email, :string
  end
end
