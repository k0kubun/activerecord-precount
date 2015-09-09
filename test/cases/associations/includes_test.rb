require 'cases/helper'

class IncludesTest < ActiveRecord::CountLoader::TestCase
  def setup
    tweets_count.times do |i|
      tweet = Tweet.create
      i.times do |j|
        Favorite.create(tweet: tweet, user_id: j + 1)
      end
    end
  end

  def teardown
    [Tweet, Favorite].each(&:delete_all)
  end

  def tweets_count
    3
  end

  def test_includes_does_not_execute_n_1_queries
    assert_queries(1 + tweets_count) { Tweet.all.map { |t| t.favorites.count } }
    assert_queries(1 + tweets_count) { Tweet.all.map(&:favorites_count) }
    assert_queries(2) { Tweet.includes(:favorites_count).map(&:favorites_count) }
  end

  def test_included_count_loader_counts_properly
    expected = Tweet.all.map { |t| t.favorites.count }
    assert_equal(expected, Tweet.all.map(&:favorites_count))
    assert_equal(expected, Tweet.includes(:favorites_count).map(&:favorites_count))
  end

  def test_included_count_loader_with_scope_counts_properly
    expected = Tweet.all.map { |t| t.my_favorites.count }
    assert_equal(expected, Tweet.all.map(&:my_favorites_count))
    assert_equal(expected, Tweet.includes(:my_favorites_count).map(&:my_favorites_count))
  end
end
