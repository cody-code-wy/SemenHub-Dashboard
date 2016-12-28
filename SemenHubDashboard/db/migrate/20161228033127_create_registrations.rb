class CreateRegistrations < ActiveRecord::Migration[5.0]
  def change
    create_table :registrations do |t|
      t.references :registrar, foreign_key: true
      t.string :registration
      t.text :note
    end
  end
end
