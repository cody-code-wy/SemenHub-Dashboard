class SaveAuthorizationAndTransactionIdOnPurchase < ActiveRecord::Migration[5.0]
  def change
    add_column :purchases, :authorization_code, :string
    add_column :purchases, :transaction_id, :string
  end
end
