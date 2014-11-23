$LOAD_PATH.unshift File.expand_path('../test', __FILE__)

require 'rbench'
require 'cases/db_config'
require 'models/tweet'
require 'models/favorite'

RBench.run(50) do
  column :counter_cache, title: 'counter_cache'
  column :count_loader,  title: 'count_loader'
  column :left_join,     title: 'LEFT JOIN'
  column :count_query,   title: 'N+1 COUNT'
  column :has_many,      title: 'preload has_many'

  join_relation = Tweet.joins('LEFT JOIN favorites ON tweets.id = favorites.tweet_id').
    select('tweets.*, COUNT(favorites.id) AS favorites_count').group('tweets.id')

  def prepare_records(tweets_count, favorites_count)
    tweets_count.times do
      t = Tweet.create(favorites_count_cache: 0)
      favorites_count.times { Favorite.create(tweet: t) }
    end
  end

  test_cases = [
    [10, 5],
    [20, 20],
    [30, 100],
  ]

  test_cases.each do |tweets_count, favorites_count|
    prepare_records(tweets_count, favorites_count)

    report "N = #{tweets_count}, count = #{favorites_count}" do
      counter_cache { Tweet.first(tweets_count).map(&:favorites_count_cache) }
      count_loader  { Tweet.preload(:favorites_count).first(tweets_count).map(&:favorites_count) }
      left_join     { join_relation.first(tweets_count).map(&:favorites_count) }
      count_query   { Tweet.first(tweets_count).map{ |t| t.favorites.count } }
      has_many      { Tweet.preload(:favorites).first(tweets_count).map{ |t| t.favorites.size } }
    end
  end
end
