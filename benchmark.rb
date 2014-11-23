$LOAD_PATH.unshift File.expand_path('../test', __FILE__)

require 'config'

require 'active_record'
require 'activerecord-count_loader'

require 'support/config'
require 'support/connection'

# Connect to the database
ARTest.connect

def load_schema
  # silence verbose schema loading
  original_stdout = $stdout
  $stdout = StringIO.new

  adapter_name = ActiveRecord::Base.connection.adapter_name.downcase

  load SCHEMA_ROOT + "/schema.rb"
ensure
  $stdout = original_stdout
end

load_schema


require 'models/tweet'
require 'models/favorite'

TWEET_COUNT = 20
FAVORITE_COUNT = 5

TWEET_COUNT.times do
  tweet = Tweet.create(favorites_count_cache: 0)

  replies = FAVORITE_COUNT.times.map do
    Favorite.create(tweet: tweet)
  end
end

def assert_equal(expect, actual)
  raise "Expected #{expect}, but got #{actual}" if expect != actual
end

Benchmark.bmbm do |bench|
  bench.report("counter_cache         ") do
    tweets = Tweet.first(TWEET_COUNT)

    tweets.each do |t|
      assert_equal(FAVORITE_COUNT, t.favorites_count_cache)
    end
  end

  bench.report("N+1 COUNT query       ") do
    tweets = Tweet.first(TWEET_COUNT)

    tweets.each do |t|
      assert_equal(FAVORITE_COUNT, t.favorites.count)
    end
  end

  bench.report("LEFT JOIN             ") do
    tweets = Tweet.joins('LEFT JOIN favorites ON tweets.id = favorites.tweet_id').
      select('tweets.*, COUNT(favorites.id) AS favorites_count').
      group('tweets.id').first(TWEET_COUNT)

    tweets.each do |t|
      assert_equal(FAVORITE_COUNT, t.favorites_count)
    end
  end

  bench.report("preloaded count_loader") do
    tweets = Tweet.preload(:favorites_count).first(TWEET_COUNT)

    tweets.each do |t|
      assert_equal(FAVORITE_COUNT, t.favorites_count)
    end
  end

  bench.report("preloaded has_many    ") do
    tweets = Tweet.preload(:favorites).first(TWEET_COUNT)

    tweets.each do |t|
      assert_equal(FAVORITE_COUNT, t.favorites.size)
    end
  end
end
