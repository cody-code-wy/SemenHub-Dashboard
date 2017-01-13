class CreateCountries < ActiveRecord::Migration[5.0]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :alpha_2, limit: 2
      t.string :alpha_3, limit: 3, default: ''

      t.timestamps
    end
  end
end
