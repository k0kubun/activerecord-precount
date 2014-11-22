class Tweet < ActiveRecord::Base
  belongs_to :user
  belongs_to :tweet
  has_many :favorites
  has_many :replies, class_name: 'Tweet'
  has_count :favorites
  has_count :replies, class_name: 'Tweet'
end
