class Reply < ActiveRecord::Base
  belongs_to :tweet, counter_cache: :replies_count_cache
end
