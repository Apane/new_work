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

ActiveRecord::Schema.define(version: 20140328170542) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "activities", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.string   "location"
    t.date     "date"
    t.string   "time"
    t.datetime "activity_date"
    t.float    "lat"
    t.float    "lng"
    t.string   "location_name"
    t.boolean  "activity_type"
    t.string   "postal_code"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.string   "district"
    t.integer  "frequency_id"
    t.integer  "category_id"
    t.integer  "gender",        default: 0
    t.integer  "ethnicity_id"
    t.integer  "age_min",       default: 18
    t.integer  "age_max",       default: 80
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
  end

  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "authorizations", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.string   "token"
    t.string   "secret"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "name"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "connections_count"
  end

  create_table "blocked_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "blocked_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.integer  "commentable_id",   default: 0
    t.string   "commentable_type"
    t.string   "title"
    t.text     "body"
    t.string   "subject"
    t.integer  "user_id",          default: 0, null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "conversations", force: true do |t|
    t.integer  "author_id"
    t.integer  "companion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "educations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "ethnicities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "event_participants", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "is_waiting", default: 0
  end

  create_table "events", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.date     "date"
    t.string   "location"
    t.string   "gps_location"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time"
    t.datetime "event_date"
    t.float    "lat"
    t.float    "lng"
    t.string   "location_name"
    t.boolean  "event_type",    default: false
    t.integer  "max_attendees"
    t.string   "postal_code"
    t.string   "country"
    t.string   "state"
    t.string   "district"
    t.string   "city"
    t.string   "image"
    t.integer  "category_id"
    t.integer  "gender",        default: 0
    t.integer  "ethnicity_id"
    t.integer  "age_min",       default: 18
    t.integer  "age_max",       default: 80
    t.string   "slug"
  end

  add_index "events", ["slug"], name: "index_events_on_slug", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "favorites", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "favorite_id"
  end

  create_table "hidden_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "hidden_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mail_settings", force: true do |t|
    t.integer  "user_id"
    t.boolean  "new_message",      default: true
    t.boolean  "new_reply",        default: true
    t.boolean  "join_event",       default: true
    t.boolean  "comment_on_event", default: true
    t.boolean  "viewed_profile",   default: true
    t.boolean  "newsletter",       default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.integer  "conversation_id"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_new",          default: true
  end

  create_table "notifications", force: true do |t|
    t.integer  "noteable_id"
    t.string   "noteable_type"
    t.string   "content"
    t.integer  "user_id"
    t.boolean  "is_opened",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", force: true do |t|
    t.string   "file"
    t.integer  "attachable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachable_type"
    t.string   "title"
    t.text     "description"
    t.boolean  "profile_photo",   default: false
  end

  add_index "photos", ["attachable_id"], name: "index_photos_on_attachable_id", using: :btree
  add_index "photos", ["attachable_type"], name: "index_photos_on_attachable_type", using: :btree

  create_table "questions", force: true do |t|
    t.string   "question"
    t.text     "answer"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "for_about"
    t.boolean  "for_personality"
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
    t.string   "zip"
    t.integer  "gender"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birthday"
    t.string   "occupation"
    t.string   "address"
    t.text     "aboutme"
    t.string   "profile_image"
    t.string   "name"
    t.integer  "age"
    t.integer  "ethnicity_id"
    t.integer  "education_id"
    t.text     "blurb"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "unconfirmed_email"
    t.float    "lat"
    t.float    "lng"
    t.string   "city"
    t.datetime "disabled_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "visits", force: true do |t|
    t.integer  "user_id"
    t.integer  "visitor_id"
    t.datetime "visited_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
