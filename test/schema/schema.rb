ActiveRecord::Schema.define do
  create_table :favorites, force: true do |t|
    t.integer  :tweet_id
    t.integer  :user_id
    t.timestamps null: false
  end
  add_index :favorites, :tweet_id

  create_table :notifications, force: true do |t|
    t.integer  :notifiable_id
    t.string   :notifiable_type
    t.timestamps null: false
  end
  add_index :notifications, [:notifiable_id, :notifiable_type]

  create_table :tweets, force: true do |t|
    t.integer  :in_reply_to_tweet_id
    t.integer  :user_id
    t.integer  :favorites_count_cache
    t.timestamps null: false
  end
  add_index :tweets, :in_reply_to_tweet_id

  create_table :users, force: true do |t|
    t.timestamps null: false
  end
end
