class TempPassToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :temp_pass, :boolean, default: false
  end
end
