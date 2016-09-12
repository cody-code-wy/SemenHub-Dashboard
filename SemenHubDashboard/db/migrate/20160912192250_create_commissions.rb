class CreateCommissions < ActiveRecord::Migration[5.0]
  def change
    create_table :commissions do |t|
      t.float :commission_percent
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
