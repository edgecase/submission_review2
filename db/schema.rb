# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110217013148) do

  create_table "invitations", :force => true do |t|
    t.integer  "subject_id"
    t.string   "subject_type"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token",        :limit => 40
    t.integer  "user_id"
    t.datetime "accepted_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.text     "highlight"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "author_id"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "presentations", :force => true do |t|
    t.integer  "presenter_id"
    t.integer  "proposal_id"
    t.integer  "talk_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "presentations", ["proposal_id"], :name => "index_presentations_on_proposal_id"

  create_table "proposal_votes", :force => true do |t|
    t.integer  "vote_id"
    t.integer  "proposal_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proposals", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "abstract"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",       :default => "submitted"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "reviewer_id"
    t.integer  "proposal_id"
    t.integer  "score"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["proposal_id", "reviewer_id"], :name => "index_ratings_on_proposal_id_and_reviewer_id"

  create_table "reviewers", :force => true do |t|
    t.string   "twitter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",      :default => false
  end

  create_table "room_slots", :force => true do |t|
    t.integer  "slot_id"
    t.integer  "proposal_id"
    t.string   "room_ref"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slots", :force => true do |t|
    t.string   "break"
    t.integer  "day_number"
    t.time     "start"
    t.time     "finish"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.text     "bio"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "twitter_username"
    t.string   "friendfeed_username"
    t.string   "personal_url"
    t.string   "company_name"
    t.string   "company_url"
    t.boolean  "company_badge"
    t.boolean  "staff"
    t.datetime "confirmed_at"
    t.boolean  "listed",               :default => true
    t.string   "company_position"
    t.string   "location"
  end

  create_table "votes", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "size"
    t.text     "diet"
    t.text     "funny"
  end

end
