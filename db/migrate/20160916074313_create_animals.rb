class CreateAnimals < ActiveRecord::Migration[5.0]
  def change
    create_table :animals do |t|
      t.integer :registration_type
      t.string :registration
      t.string :name
      t.integer :owner_id
      t.references :breed, foreign_key: true

      t.timestamps
    end
  end
end
