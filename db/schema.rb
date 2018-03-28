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

ActiveRecord::Schema.define(version: 20171115235603) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "authentication_providers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_name_on_authentication_providers", using: :btree
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name",         limit: 50
    t.string   "postal_code",  limit: 10
    t.string   "department",   limit: 2
    t.string   "region",       limit: 10
    t.string   "country_code", limit: 2
    t.decimal  "lat",                     precision: 9, scale: 6
    t.decimal  "lon",                     precision: 9, scale: 6
    t.decimal  "distance",                precision: 4, scale: 2
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.index ["name"], name: "index_cities_on_name", using: :btree
  end

  create_table "cms_page_parts", force: :cascade do |t|
    t.string   "name"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cms_pages", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "title"
    t.string   "meta_desc"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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

  create_table "geonames", force: :cascade do |t|
    t.string  "country_code", limit: 2
    t.string  "postal_code",  limit: 20
    t.string  "place_name",   limit: 180
    t.string  "admin_name1",  limit: 100
    t.string  "admin_code1",  limit: 20
    t.string  "admin_name2",  limit: 100
    t.string  "admin_code2",  limit: 20
    t.string  "admin_name3",  limit: 100
    t.string  "admin_code3",  limit: 20
    t.decimal "latitude",                 precision: 9, scale: 6
    t.decimal "longitude",                precision: 9, scale: 6
    t.integer "accuracy"
    t.index ["place_name"], name: "index_geonames_on_place_name", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "trip_id"
    t.string   "sender_name"
    t.string   "sender_email"
    t.text     "body"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "sender_phone"
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
    t.index ["kind"], name: "index_points_on_kind", using: :btree
    t.index ["rank"], name: "index_points_on_rank", using: :btree
    t.index ["trip_id"], name: "index_points_on_trip_id", using: :btree
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
    t.boolean  "terms_of_service"
    t.float    "total_distance"
    t.float    "total_time"
    t.integer  "user_id"
    t.datetime "last_trip_information_at"
    t.index ["confirmation_token"], name: "index_trips_on_confirmation_token", using: :btree
    t.index ["created_at"], name: "index_trips_on_created_at", using: :btree
    t.index ["departure_date"], name: "index_trips_on_departure_date", using: :btree
    t.index ["departure_time"], name: "index_trips_on_departure_time", using: :btree
    t.index ["edition_token"], name: "index_trips_on_edition_token", using: :btree
    t.index ["state"], name: "index_trips_on_state", using: :btree
    t.index ["user_id"], name: "index_trips_on_user_id", using: :btree
  end

  create_table "user_authentications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "authentication_provider_id"
    t.string   "uid"
    t.string   "token"
    t.datetime "token_expires_at"
    t.text     "params"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["authentication_provider_id"], name: "index_user_authentications_on_authentication_provider_id", using: :btree
    t.index ["user_id"], name: "index_user_authentications_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "role",                   limit: 10
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "messages", "trips"
  add_foreign_key "points", "trips"
  add_foreign_key "trips", "users"
end
