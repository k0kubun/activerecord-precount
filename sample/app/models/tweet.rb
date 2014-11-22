class Tweet < ActiveRecord::Base
  belongs_to :user
  belongs_to :in_reply_to, class_name: 'Tweet', foreign_key: :in_reply_to_tweet_id
  has_many :favorites
  has_many :replies, class_name: 'Tweet', foreign_key: :in_reply_to_tweet_id
  count_loader :favorites
  count_loader :replies, class_name: 'Tweet', foreign_key: :in_reply_to_tweet_id
end
