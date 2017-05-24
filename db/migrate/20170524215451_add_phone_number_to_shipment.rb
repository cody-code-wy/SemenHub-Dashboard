class AddPhoneNumberToShipment < ActiveRecord::Migration[5.0]
  def change
    add_column :shipments, :phone_number, :string
  end
end
