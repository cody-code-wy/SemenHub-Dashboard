class AddAnimalLineageAndGender < ActiveRecord::Migration[5.0]
  def change
    change_table :animals do |t|
      t.boolean :is_male, default: true, null: false
      t.references :sire, null: true, class: :animal
      t.references :dam, null: true, class: :animal
    end
  end
end
