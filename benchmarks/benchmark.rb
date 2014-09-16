require "benchmark"
require "pry"
require "active_record"
require "activerecord-has_count"

spec_dir = File.expand_path("../../spec", __FILE__)
Dir[File.join(spec_dir, "models/*.rb")].each { |f| require f }

database_yml = File.join(spec_dir, "database.yml")
ActiveRecord::Base.configurations["bench"] = YAML.load_file(database_yml)["bench"]
ActiveRecord::Base.establish_connection :bench

def silently_execute(&block)
  stdout_old = $stdout.dup
  $stdout.reopen("/tmp/bench")
  block.call
  $stdout.flush
  $stdout.reopen stdout_old
end

def assert_equal(expect, actual)
  raise "Expected #{expect}, but got #{actual}" if expect != actual
end

silently_execute do
  ActiveRecord::Schema.define do
    create_table :tweets, force: true do |t|
      t.column :replies_count_cache, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end

    create_table :replies, force: true do |t|
      t.column :tweet_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    add_index :replies, [:tweet_id], name: "index_replies_on_tweet_id", using: :btree
  end
end

[Tweet, Reply].each(&:delete_all)

TWEET_COUNT = 10
REPLY_COUNT = 1000

TWEET_COUNT.times do
  tweet = Tweet.create(replies_count_cache: 0)

  replies = REPLY_COUNT.times.map do
    Reply.create(tweet: tweet)
  end
end

Benchmark.bm do |bench|
  bench.report("counter_cache      ") do
    tweets = Tweet.first(TWEET_COUNT)

    tweets.each do |t|
      assert_equal(REPLY_COUNT, t.replies_count_cache)
    end
  end

  bench.report("N+1 COUNT query    ") do
    tweets = Tweet.first(TWEET_COUNT)

    tweets.each do |t|
      assert_equal(REPLY_COUNT, t.replies.count)
    end
  end

  bench.report("LEFT JOIN          ") do
    tweets = Tweet.joins('LEFT JOIN replies ON tweets.id = replies.tweet_id').
      select('tweets.*, COUNT(replies.id) AS replies_count').
      group('tweets.id').first(TWEET_COUNT)

    tweets.each do |t|
      assert_equal(REPLY_COUNT, t.replies_count)
    end
  end

  bench.report("preloaded has_count") do
    tweets = Tweet.preload(:replies_count).first(TWEET_COUNT)

    tweets.each do |t|
      assert_equal(REPLY_COUNT, t.replies_count)
    end
  end

  bench.report("preloaded has_many ") do
    tweets = Tweet.preload(:replies).first(TWEET_COUNT)

    tweets.each do |t|
      assert_equal(REPLY_COUNT, t.replies.size)
    end
  end
end
