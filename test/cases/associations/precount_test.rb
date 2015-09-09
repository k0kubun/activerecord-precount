require 'cases/helper'

class PrecountTest < ActiveRecord::CountLoader::TestCase
  def setup
    tweets_count.times do |i|
      tweet = Tweet.create
      i.times do |j|
        Favorite.create(tweet: tweet, user_id: j + 1)
      end
    end

    if Tweet.has_reflection?(:favs_count)
      if ActiveRecord::VERSION::MAJOR >= 4 && ActiveRecord::VERSION::MINOR >= 2
        Tweet._reflections.delete('favs_count')
      else
        Tweet._reflections.delete(:favs_count)
      end
    end
  end

  def teardown
    [Tweet, Favorite].each(&:delete_all)
  end

  def tweets_count
    3
  end

  def test_precount_defines_count_loader
    assert_equal(false, Tweet.has_reflection?(:favs_count))
    Tweet.precount(:favs).map(&:favs_count)
    assert_equal(true, Tweet.has_reflection?(:favs_count))
  end

  def test_precount_has_many_with_count_loader_does_not_execute_n_1_queries
    assert_queries(1 + tweets_count) { Tweet.all.map { |t| t.favorites.count } }
    assert_queries(1 + tweets_count) { Tweet.all.map(&:favorites_count) }
    assert_queries(2) { Tweet.precount(:favorites).map { |t| t.favorites.count } }
    assert_queries(2) { Tweet.precount(:favorites).map(&:favorites_count) }
  end

  def test_precount_has_many_counts_properly
    expected = Tweet.all.map { |t| t.favorites.count }
    assert_equal(expected, Tweet.all.map(&:favorites_count))
    assert_equal(expected, Tweet.precount(:favorites).map { |t| t.favorites.count })
    assert_equal(expected, Tweet.precount(:favorites).map(&:favorites_count))
  end

  def test_precount_has_many_with_scope_counts_properly
    expected = Tweet.all.map { |t| t.my_favs.count }
    assert_equal(expected, Tweet.precount(:my_favs).map { |t| t.my_favs.count })
    assert_equal(expected, Tweet.precount(:my_favs).map(&:my_favs_count))
  end
end
