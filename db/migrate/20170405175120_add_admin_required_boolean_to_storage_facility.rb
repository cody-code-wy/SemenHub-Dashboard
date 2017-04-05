class AddAdminRequiredBooleanToStorageFacility < ActiveRecord::Migration[5.0]
  def change
    add_column :storage_facilities, :admin_required, :boolean, default: true
  end
end
