class AddFacilityName < ActiveRecord::Migration[5.0]
  def change
    add_column :storage_facilities, :name, :string
  end
end
;