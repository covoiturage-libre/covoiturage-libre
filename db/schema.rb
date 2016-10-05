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

ActiveRecord::Schema.define(version: 20160524170347) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "points", force: :cascade do |t|
    t.string   "kind"
    t.integer  "rank"
    t.integer  "trip_id"
    t.decimal  "lat",              precision: 9, scale: 6
    t.decimal  "decimal",          precision: 9, scale: 6
    t.decimal  "lon",              precision: 9, scale: 6
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "zipcode"
    t.string   "country_iso_code"
    t.integer  "price"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["trip_id"], name: "index_points_on_trip_id", using: :btree
  end

  create_table "trips", force: :cascade do |t|
    t.datetime "leave_at",                           null: false
    t.integer  "seats"
    t.string   "comfort"
    t.text     "description"
    t.integer  "price"
    t.string   "title"
    t.boolean  "smoking",        default: false,     null: false
    t.string   "name"
    t.integer  "age"
    t.string   "email"
    t.string   "phone"
    t.string   "creation_token"
    t.string   "edition_token"
    t.string   "deletion_token"
    t.string   "state",          default: "pending"
    t.string   "creation_ip"
    t.string   "deletion_ip"
    t.string   "kind"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_foreign_key "points", "trips"
end
