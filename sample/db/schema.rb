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

ActiveRecord::Schema.define(version: 20141122002555) do

  create_table "favorites", force: :cascade do |t|
    t.integer  "tweet_id",   limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["tweet_id"], name: "index_favorites_on_tweet_id", using: :btree

  create_table "tweets", force: :cascade do |t|
    t.integer  "in_reply_to_tweet_id", limit: 4
    t.integer  "user_id",              limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tweets", ["in_reply_to_tweet_id"], name: "index_tweets_on_in_reply_to_tweet_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
