class CreateRegistrars < ActiveRecord::Migration[5.0]
  def change
    create_table :registrars do |t|
      t.references :breed, foreign_key: true
      t.references :address, foreign_key: true

      t.string :name
      t.string :phone_primary
      t.string :phone_secondary
      t.string :email
      t.string :website
      t.text :note

      t.timestamps
    end
  end
end
