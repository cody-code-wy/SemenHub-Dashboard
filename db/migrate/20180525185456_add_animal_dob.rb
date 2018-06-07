class AddAnimalDob < ActiveRecord::Migration[5.0]
  def change
    add_column :animals, :date_of_birth, :date
  end
end
