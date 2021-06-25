# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_25_115503) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "carrefour_units", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "cep"
    t.string "suburb"
    t.string "city"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "latitude"
    t.float "longitude"
  end

  create_table "item_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "trades", force: :cascade do |t|
    t.integer "buyer_id"
    t.integer "seller_id"
    t.integer "carrefour_unit_id"
    t.integer "item_category_id"
    t.datetime "date"
    t.string "item"
    t.boolean "buyer_accepted", default: false
    t.boolean "seller_accepted", default: false
    t.string "buyer_cep"
    t.string "seller_cep"
    t.string "receiver_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "receiver_name"
    t.integer "author_id"
    t.string "author_role"
    t.float "lat_buyer"
    t.float "long_buyer"
    t.float "lat_seller"
    t.float "long_seller"
    t.index ["carrefour_unit_id"], name: "index_trades_on_carrefour_unit_id"
    t.index ["item_category_id"], name: "index_trades_on_item_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "cpf"
    t.date "birthdate"
    t.string "phone"
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "trades", "carrefour_units"
  add_foreign_key "trades", "item_categories"
end
