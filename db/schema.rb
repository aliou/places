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

ActiveRecord::Schema.define(version: 20141227171916) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "icon_url",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "metadata"
  end

  create_table "places", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.float    "lat"
    t.float    "lng"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "foursquare_venue_id", limit: 255
    t.string   "address",             limit: 255
    t.hstore   "metadata"
    t.integer  "category_id"
  end

  add_index "places", ["category_id"], name: "index_places_on_category_id", using: :btree
  add_index "places", ["user_id"], name: "index_places_on_user_id", using: :btree

  create_table "user_place_importers", force: :cascade do |t|
    t.datetime "last_imported_at"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "user_place_importers", ["user_id"], name: "index_user_place_importers_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "uid",         limit: 255
    t.string   "provider",    limit: 255
    t.string   "oauth_token", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
