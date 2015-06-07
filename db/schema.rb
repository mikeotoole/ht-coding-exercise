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

ActiveRecord::Schema.define(version: 20150606214812) do

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree

  create_table "sf311_cases", force: :cascade do |t|
    t.integer  "category_id",         limit: 4,                             null: false
    t.integer  "source_id",           limit: 4,                             null: false
    t.string   "request_details",     limit: 255
    t.string   "address",             limit: 255,                           null: false
    t.string   "request_type",        limit: 255,                           null: false
    t.datetime "last_updated_at",                                           null: false
    t.string   "neighborhood",        limit: 255,                           null: false
    t.integer  "case_id",             limit: 4,                             null: false
    t.datetime "closed_at"
    t.integer  "supervisor_district", limit: 4,                             null: false
    t.string   "responsible_agency",  limit: 255,                           null: false
    t.datetime "opened_at",                                                 null: false
    t.decimal  "latitude",                        precision: 16, scale: 13, null: false
    t.decimal  "longitude",                       precision: 16, scale: 13, null: false
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
  end

  add_index "sf311_cases", ["case_id"], name: "index_sf311_cases_on_case_id", unique: true, using: :btree
  add_index "sf311_cases", ["category_id"], name: "index_sf311_cases_on_category_id", using: :btree
  add_index "sf311_cases", ["closed_at"], name: "index_sf311_cases_on_closed_at", using: :btree
  add_index "sf311_cases", ["latitude"], name: "index_sf311_cases_on_latitude", using: :btree
  add_index "sf311_cases", ["longitude"], name: "index_sf311_cases_on_longitude", using: :btree
  add_index "sf311_cases", ["opened_at"], name: "index_sf311_cases_on_opened_at", using: :btree
  add_index "sf311_cases", ["source_id"], name: "index_sf311_cases_on_source_id", using: :btree

  create_table "sources", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "sources", ["name"], name: "index_sources_on_name", unique: true, using: :btree

end
