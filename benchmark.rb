$LOAD_PATH.unshift File.expand_path('../test', __FILE__)

require 'benchmark/ips'
require 'cases/db_config'
require 'models/favorite'
require 'models/tweet'

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
  [30, 100],
  [50, 10],
]

test_cases.each do |tweets_count, favorites_count|
  prepare_records(tweets_count, favorites_count)

  puts "N = #{tweets_count}, count = #{favorites_count}"
  Benchmark.ips do |x|
    x.report('counter_cache')    { Tweet.all.map(&:favorites_count_cache) }
    x.report('LEFT JOIN')        { Tweet.joins('LEFT JOIN favorites ON tweets.id = favorites.tweet_id').
                                   select('tweets.*, COUNT(favorites.id) AS joined_count').
                                   group('tweets.id').map(&:joined_count) }
    x.report('eager_count')      { Tweet.eager_count(:favorites).map(&:favorites_count) }
    x.report('precount')         { Tweet.precount(:favorites).map(&:favorites_count) }
    x.report('slow eager_count') { Tweet.eager_count(:favorites).map { |t| t.favorites.count } }
    x.report('slow precount')    { Tweet.precount(:favorites).map { |t| t.favorites.count } }
    x.report('preload')          { Tweet.preload(:favorites).map{ |t| t.favorites.size } }
    x.report('N+1 COUNT')        { Tweet.all.map{ |t| t.favorites.count } }
    x.compare!
  end
end
