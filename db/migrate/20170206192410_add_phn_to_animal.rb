class AddPhnToAnimal < ActiveRecord::Migration[5.0]
  def change
    add_column :animals, :private_herd_number, :string
  end
end
