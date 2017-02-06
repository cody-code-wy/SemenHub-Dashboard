class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :spouse_name
      t.string :email
      t.string :phone_primary
      t.string :phone_secondary
      t.string :website
      # t.integer :mailing_address_id
      # t.integer :billing_address_id
      # t.integer :payee_address_id
      t.references :mailing_address, references: :address
      t.references :billing_address, references: :address
      t.references :payee_address, references: :address, null: true

      t.timestamps
    end
  end
end
