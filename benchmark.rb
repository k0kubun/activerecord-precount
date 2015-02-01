$LOAD_PATH.unshift File.expand_path('../test', __FILE__)

require 'rbench'
require 'cases/db_config'
require 'models/favorite'
require 'models/tweet'

RBench.run(50) do
  column :counter_cache,          title: 'counter_cache'
  column :left_join,              title: 'LEFT JOIN'
  column :eager_count,            title: 'eager_count'
  column :precount,               title: 'precount'
  column :slow_eager_count,       title: 'slow eager_count'
  column :slow_precount,          title: 'slow precount'
  column :has_many,               title: 'preload'
  column :count_query,            title: 'N+1 COUNT'

  join_relation = Tweet.joins('LEFT JOIN favorites ON tweets.id = favorites.tweet_id').
    select('tweets.*, COUNT(favorites.id) AS joined_count').group('tweets.id')

  def prepare_records(tweets_count, favorites_count)
    Tweet.delete_all
    Favorite.delete_all

    tweets_count.times do
      t = Tweet.create(favorites_count_cache: 0)
      favorites_count.times { Favorite.create(tweet: t) }
    end
  end

  test_cases = [
    [10, 5],
    [20, 20],
    [30, 100],
    [50, 10],
  ]

  test_cases.each do |tweets_count, favorites_count|
    prepare_records(tweets_count, favorites_count)

    report "N = #{tweets_count}, count = #{favorites_count}" do
      counter_cache          { Tweet.all.map(&:favorites_count_cache) }
      left_join              { Tweet.joins('LEFT JOIN favorites ON tweets.id = favorites.tweet_id').
                               select('tweets.*, COUNT(favorites.id) AS joined_count').
                               group('tweets.id').map(&:joined_count) }
      eager_count            { Tweet.eager_count(:favorites).map(&:favorites_count) }
      precount               { Tweet.precount(:favorites).map(&:favorites_count) }
      slow_eager_count       { Tweet.eager_count(:favorites).map { |t| t.favorites.count } }
      slow_precount          { Tweet.precount(:favorites).map { |t| t.favorites.count } }
      has_many               { Tweet.preload(:favorites).map{ |t| t.favorites.size } }
      count_query            { Tweet.all.map{ |t| t.favorites.count } }
    end
  end
end
