class OldFeeRemoval < ActiveRecord::Migration[5.0]
  def change
    change_table :storage_facilities do |t|
      t.remove :storage_fee, :release_fee
    end
  end
end
