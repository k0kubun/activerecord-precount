class Favorite < ActiveRecord::Base
  belongs_to :tweet, counter_cache: :favorites_count_cache
  has_many :notifications, as: :notifiable, foreign_key: :notifiable_id
end
