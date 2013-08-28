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

ActiveRecord::Schema.define(version: 20130828054750) do

  create_table "request_for_changes", force: true do |t|
    t.string   "noc_tracking_url"
    t.string   "webteh_tracking_url"
    t.boolean  "type_network"
    t.boolean  "type_servers"
    t.boolean  "type_application"
    t.boolean  "type_user_management"
    t.integer  "requestor_id"
    t.string   "description_of_change"
    t.boolean  "change_repair"
    t.boolean  "change_removal"
    t.boolean  "change_emergency"
    t.boolean  "change_other"
    t.date     "request_implement_window"
    t.string   "systems_affected"
    t.string   "users_affected"
    t.string   "criticality_of_change"
    t.text     "test_plan"
    t.text     "back_out_plan"
    t.integer  "management_approver_id"
    t.string   "mgmt_approval_status"
    t.string   "mgmt_approval_comments"
    t.date     "change_scheduled_for"
    t.date     "mgmt_decision_date"
    t.integer  "security_approver_id"
    t.string   "sec_approval_status"
    t.string   "sec_approval_comments"
    t.date     "sec_decision_date"
    t.integer  "implementor_id"
    t.string   "implementation_status"
    t.string   "implement_comments"
    t.date     "implementation_start"
    t.date     "implementation_end"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "type_documentation"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "company"
    t.string   "full_name"
    t.string   "title"
    t.string   "role"
    t.boolean  "user_admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

end
