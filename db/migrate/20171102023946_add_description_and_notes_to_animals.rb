class AddDescriptionAndNotesToAnimals < ActiveRecord::Migration[5.0]
  def change
    add_column :animals, :description, :string
    add_column :animals, :notes, :string
  end
end
