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

ActiveRecord::Schema.define(version: 2019_06_17_212033) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.string "url_address"
    t.string "username"
    t.string "password"
  end

  create_table "student_attendances", force: :cascade do |t|
    t.bigint "zone_id"
    t.string "identifier"
    t.datetime "first_seen_at"
    t.datetime "last_seen_at"
    t.index ["zone_id"], name: "index_student_attendances_on_zone_id"
  end

  create_table "zones", force: :cascade do |t|
    t.bigint "school_id"
    t.string "name"
    t.index ["school_id"], name: "index_zones_on_school_id"
  end

  add_foreign_key "student_attendances", "zones"
end
