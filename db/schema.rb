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

ActiveRecord::Schema.define(version: 20160916163651) do

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"

  create_table "equipment", force: :cascade do |t|
    t.string   "equipment_name"
    t.string   "model"
    t.string   "engineer"
    t.string   "job_sheet_number"
    t.string   "supplier"
    t.string   "supplier_invoice_number"
    t.string   "supplier_Warranty_start"
    t.string   "supplier_Warranty_end"
    t.string   "customer_Warranty_start"
    t.string   "customer_Warranty_end"
    t.integer  "specification_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "warranty_alert"
    t.string   "technician_report"
  end

  add_index "equipment", ["specification_id"], name: "index_equipment_on_specification_id"

  create_table "serials", force: :cascade do |t|
    t.string   "serial_number"
    t.integer  "equipment_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "serials", ["equipment_id"], name: "index_serials_on_equipment_id"

  create_table "specifications", force: :cascade do |t|
    t.string   "case"
    t.string   "title"
    t.string   "client"
    t.string   "contact_person"
    t.string   "email"
    t.string   "telephone"
    t.string   "comment"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "author"
    t.boolean  "tested"
  end

  create_table "users", force: :cascade do |t|
    t.string   "login"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "group_strings"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "name"
  end

end
