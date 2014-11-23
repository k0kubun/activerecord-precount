ActiveRecord::Schema.define do
  create_table :favorites, force: true do |t|
    t.integer  :tweet_id
    t.integer  :user_id
    t.datetime :created_at
    t.timestamps
  end

  create_table :tweets, force: true do |t|
    t.integer  :in_reply_to_tweet_id
    t.integer  :user_id
    t.timestamps
  end
end
