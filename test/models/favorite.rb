class Favorite < ActiveRecord::Base
  belongs_to :tweet, counter_cache: :favorites_count_cache
end
