# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170312195237) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "line1"
    t.string   "line2"
    t.string   "postal_code"
    t.string   "city"
    t.string   "region"
    t.string   "alpha_2",     limit: 2
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "animals", force: :cascade do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.integer  "breed_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "private_herd_number"
    t.string   "dna_number"
    t.index ["breed_id"], name: "index_animals_on_breed_id", using: :btree
  end

  create_table "breeds", force: :cascade do |t|
    t.string   "breed_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "commissions", force: :cascade do |t|
    t.float    "commission_percent"
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["user_id"], name: "index_commissions_on_user_id", using: :btree
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.string   "alpha_2",    limit: 2
    t.string   "alpha_3",    limit: 3, default: ""
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "fees", force: :cascade do |t|
    t.decimal  "price"
    t.integer  "fee_type"
    t.integer  "storage_facility_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["storage_facility_id"], name: "index_fees_on_storage_facility_id", using: :btree
  end

  create_table "inventory_transactions", force: :cascade do |t|
    t.integer  "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "sku_id"
    t.index ["sku_id"], name: "index_inventory_transactions_on_sku_id", using: :btree
  end

  create_table "permission_assignments", force: :cascade do |t|
    t.integer  "role_id"
    t.integer  "permission_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["permission_id"], name: "index_permission_assignments_on_permission_id", using: :btree
    t.index ["role_id"], name: "index_permission_assignments_on_role_id", using: :btree
  end

  create_table "permissions", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "purchase_transactions", force: :cascade do |t|
    t.integer  "purchase_id"
    t.integer  "inventory_transaction_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["inventory_transaction_id"], name: "index_purchase_transactions_on_inventory_transaction_id", using: :btree
    t.index ["purchase_id"], name: "index_purchase_transactions_on_purchase_id", using: :btree
  end

  create_table "purchases", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_purchases_on_user_id", using: :btree
  end

  create_table "registrars", force: :cascade do |t|
    t.integer  "breed_id"
    t.integer  "address_id"
    t.string   "name"
    t.string   "phone_primary"
    t.string   "phone_secondary"
    t.string   "email"
    t.string   "website"
    t.text     "note"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["address_id"], name: "index_registrars_on_address_id", using: :btree
    t.index ["breed_id"], name: "index_registrars_on_breed_id", using: :btree
  end

  create_table "registrations", force: :cascade do |t|
    t.integer  "registrar_id"
    t.string   "registration"
    t.text     "note"
    t.integer  "animal_id"
    t.datetime "created_at",   default: '2017-03-12 20:06:57', null: false
    t.datetime "updated_at",   default: '2017-03-12 20:06:57', null: false
    t.index ["animal_id"], name: "index_registrations_on_animal_id", using: :btree
    t.index ["registrar_id"], name: "index_registrations_on_registrar_id", using: :btree
  end

  create_table "role_assignments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_role_assignments_on_role_id", using: :btree
    t.index ["user_id"], name: "index_role_assignments_on_user_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shipments", force: :cascade do |t|
    t.integer  "purchase_id"
    t.integer  "method"
    t.date     "requested_date"
    t.string   "location_name"
    t.string   "account_name"
    t.integer  "address_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["address_id"], name: "index_shipments_on_address_id", using: :btree
    t.index ["purchase_id"], name: "index_shipments_on_purchase_id", using: :btree
  end

  create_table "ships_tos", force: :cascade do |t|
    t.integer  "country_id"
    t.integer  "inventoryTransaction_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["country_id"], name: "index_ships_tos_on_country_id", using: :btree
    t.index ["inventoryTransaction_id"], name: "index_ships_tos_on_inventoryTransaction_id", using: :btree
  end

  create_table "skus", force: :cascade do |t|
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
    t.index ["animal_id"], name: "index_sku_on_animal_id", using: :btree
    t.index ["storagefacility_id"], name: "index_sku_on_storagefacility_id", using: :btree
  end

  create_table "storage_facilities", force: :cascade do |t|
    t.string   "phone_number"
    t.string   "website"
    t.integer  "address_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "name"
    t.string   "email"
    t.index ["address_id"], name: "index_storage_facilities_on_address_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "spouse_name"
    t.string   "email"
    t.string   "phone_primary"
    t.string   "phone_secondary"
    t.string   "website"
    t.integer  "mailing_address_id"
    t.integer  "billing_address_id"
    t.integer  "payee_address_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "password_digest"
    t.boolean  "temp_pass",          default: false
  end

  add_foreign_key "fees", "storage_facilities"
  add_foreign_key "inventory_transactions", "skus"
  add_foreign_key "permission_assignments", "permissions"
  add_foreign_key "permission_assignments", "roles"
end
