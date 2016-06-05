# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160605175941) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "full_name"
    t.string   "zip_code"
    t.string   "city"
    t.string   "street"
    t.string   "street_address"
    t.string   "nip"
    t.string   "regon"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "companies", ["nip"], name: "index_companies_on_nip", unique: true, using: :btree
  add_index "companies", ["regon"], name: "index_companies_on_regon", unique: true, using: :btree

  create_table "employees", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "work_as"
    t.date     "date_of_employment"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "manages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tools", force: :cascade do |t|
    t.string   "name"
    t.integer  "quantity"
    t.boolean  "has_card",      default: false
    t.integer  "company_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "employee_id"
    t.integer  "tools_card_id"
  end

  add_index "tools", ["company_id"], name: "index_tools_on_company_id", using: :btree
  add_index "tools", ["employee_id"], name: "index_tools_on_employee_id", using: :btree
  add_index "tools", ["tools_card_id"], name: "index_tools_on_tools_card_id", using: :btree

  create_table "tools_cards", force: :cascade do |t|
    t.integer  "employee_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "company_id",  null: false
    t.text     "content"
  end

  add_index "tools_cards", ["company_id"], name: "index_tools_cards_on_company_id", using: :btree
  add_index "tools_cards", ["employee_id"], name: "index_tools_cards_on_employee_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "tools", "employees"
  add_foreign_key "tools", "tools_cards"
  add_foreign_key "tools_cards", "companies"
  add_foreign_key "tools_cards", "employees"
end
