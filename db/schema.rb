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

ActiveRecord::Schema.define(:version => 20120819065400) do

  create_table "accounts", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                       :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["authentication_token"], :name => "index_accounts_on_authentication_token", :unique => true
  add_index "accounts", ["confirmation_token"], :name => "index_accounts_on_confirmation_token", :unique => true
  add_index "accounts", ["email"], :name => "index_accounts_on_email", :unique => true
  add_index "accounts", ["reset_password_token"], :name => "index_accounts_on_reset_password_token", :unique => true
  add_index "accounts", ["unlock_token"], :name => "index_accounts_on_unlock_token", :unique => true

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "due"
    t.datetime "completed_at"
    t.integer  "owner_id"
    t.integer  "parent_id"
    t.integer  "invited_by"
    t.string   "activity_type"
    t.text     "summary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id"
  end

  add_index "activities", ["completed_at"], :name => "index_activities_on_completed_at"
  add_index "activities", ["due"], :name => "index_activities_on_due"
  add_index "activities", ["invited_by"], :name => "index_activities_on_invited_by"
  add_index "activities", ["owner_id"], :name => "index_activities_on_owner_id"
  add_index "activities", ["parent_id"], :name => "index_activities_on_parent_id"
  add_index "activities", ["status_id"], :name => "index_activities_on_status_id"

  create_table "activities_documents", :id => false, :force => true do |t|
    t.integer  "activity_id"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activities_users", :id => false, :force => true do |t|
    t.integer  "activity_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities_users", ["activity_id"], :name => "index_activities_users_on_activity_id"
  add_index "activities_users", ["user_id"], :name => "index_activities_users_on_user_id"

  create_table "authentication_services", :force => true do |t|
    t.integer  "account_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "uname"
    t.string   "uemail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", :force => true do |t|
    t.string   "name"
    t.string   "note"
    t.string   "version"
    t.string   "file_name"
    t.integer  "document_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "last_revieweds", :force => true do |t|
    t.integer  "user_id"
    t.integer  "module_id"
    t.datetime "when"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "last_revieweds", ["user_id", "module_id"], :name => "by_user_module", :unique => true

  create_table "preferences", :force => true do |t|
    t.string   "preference"
    t.integer  "prefe_id"
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
    t.integer  "assigned_to"
    t.string   "comment"
    t.datetime "last_reviewed"
    t.datetime "proposed_date"
    t.datetime "last_status_change"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id"
  end

  add_index "tivit_user_statuses", ["activity_id", "user_id"], :name => "by_user_activity", :unique => true
  add_index "tivit_user_statuses", ["status_id"], :name => "index_tivit_user_statuses_on_status_id"

  create_table "tivitcomments", :force => true do |t|
    t.integer  "user_id"
    t.string   "comment",     :limit => 1024
    t.string   "action"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tivitcomments", ["activity_id"], :name => "index_tivitcomments_on_activity_id"
  add_index "tivitcomments", ["created_at"], :name => "index_tivitcomments_on_created_at"
  add_index "tivitcomments", ["user_id"], :name => "index_tivitcomments_on_user_id"

  create_table "user_preferences", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "preference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "clone_email"
    t.integer  "account_id"
    t.boolean  "admin",       :default => false
    t.boolean  "is_active",   :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
