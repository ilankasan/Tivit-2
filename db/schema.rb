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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110921060738) do

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "status"
    t.datetime "due"
    t.integer  "owner_id"
    t.string   "who"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "completed_at"
    t.text     "summary"
    t.string   "activity_type"
    t.integer  "parent_id"
    t.integer  "invited_by"
  end

  create_table "activities_users", :id => false, :force => true do |t|
    t.integer  "activity_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activity_documents", :force => true do |t|
    t.integer  "activity_id"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", :force => true do |t|
    t.string   "name"
    t.string   "note"
    t.string   "version"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profile_images", :force => true do |t|
    t.integer  "user_id"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tivit_user_statuses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.string   "status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comment"
    t.datetime "last_reviewed"
    t.datetime "proposed_date"
  end

  create_table "tivitcomments", :force => true do |t|
    t.integer  "user_id"
    t.string   "comment"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "encrypted_password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "salt"
    t.boolean  "admin",              :default => false
    t.boolean  "is_active",          :default => true
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
