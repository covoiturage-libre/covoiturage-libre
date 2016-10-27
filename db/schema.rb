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

ActiveRecord::Schema.define(version: 20161027090728) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "trip_id"
    t.string   "sender_name"
    t.string   "sender_email"
    t.string   "body"
    t.text     "message"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["trip_id"], name: "index_messages_on_trip_id", using: :btree
  end

  create_table "points", force: :cascade do |t|
    t.string   "kind"
    t.integer  "rank"
    t.integer  "trip_id"
    t.decimal  "lat",              precision: 9, scale: 6
    t.decimal  "lon",              precision: 9, scale: 6
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "zipcode"
    t.string   "country_iso_code"
    t.integer  "price"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index "st_geographyfromtext((((('SRID=4326;POINT('::text || lon) || ' '::text) || lat) || ')'::text))", name: "index_on_points_location", using: :gist
    t.index ["trip_id"], name: "index_points_on_trip_id", using: :btree
  end

  create_table "spatial_ref_sys", primary_key: "srid", id: :integer, force: :cascade do |t|
    t.string  "auth_name", limit: 256
    t.integer "auth_srid"
    t.string  "srtext",    limit: 2048
    t.string  "proj4text", limit: 2048
  end

  create_table "trips", force: :cascade do |t|
    t.date     "departure_date"
    t.time     "departure_time"
    t.integer  "seats"
    t.string   "comfort"
    t.text     "description"
    t.integer  "price"
    t.string   "title"
    t.boolean  "smoking",            default: false,     null: false
    t.string   "name"
    t.integer  "age"
    t.string   "email"
    t.string   "phone"
    t.string   "confirmation_token"
    t.string   "edition_token"
    t.string   "deletion_token"
    t.string   "state",              default: "pending", null: false
    t.string   "creation_ip"
    t.string   "deletion_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_foreign_key "messages", "trips"
  add_foreign_key "points", "trips"
end
