class ModifyAnimals < ActiveRecord::Migration[5.0]
  def change
    change_table :animals do |t|
      t.remove :registration, :registration_type

      t.references :registration, foreigne_key: true
    end
  end
end
