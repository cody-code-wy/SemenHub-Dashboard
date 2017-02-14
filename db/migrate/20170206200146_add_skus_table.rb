class AddSkusTable < ActiveRecord::Migration[5.0]
  def change
    create_table :skus do |t|
    t.boolean  "private"
    t.integer  "semen_type"
    t.decimal  "price_per_unit"
    t.integer  "semen_count"
    t.integer  "animal_id"
    t.integer  "storagefacility_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "seller_id"
    t.decimal  "cost_per_unit"
    t.index ["animal_id"], name: "index_sku_on_animal_id"
    t.index ["storagefacility_id"], name: "index_sku_on_storagefacility_id"
    end
  end
end
