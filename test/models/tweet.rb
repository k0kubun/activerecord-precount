class Tweet < ActiveRecord::Base
  has_many :favorites, count_loader: true
  volatile_counter_cache :favorites,
    cache: ActiveSupport::Cache::MemCacheStore.new('localhost'),
    counter_method_name: :volatile_favorites_count
end
