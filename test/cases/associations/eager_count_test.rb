require 'cases/helper'

class EagerCountTest < ActiveRecord::CountLoader::TestCase
  def setup
    tweets_count.times do |i|
      tweet = Tweet.create
      i.times do |j|
        favorite = Favorite.create(tweet: tweet, user_id: j + 1)
        Notification.create(notifiable: favorite)
        Notification.create(notifiable: tweet)
      end
    end
  end

  def teardown
    if has_reflection?(Tweet, :favs_count)
      Tweet.reflections.delete('favs_count')
    end

    [Tweet, Favorite].each(&:delete_all)
  end

  def tweets_count
    3
  end

  def test_eager_count_defines_count_loader
    assert_equal(false, has_reflection?(Tweet, :favs_count))
    Tweet.eager_count(:favs).map(&:favs_count)
    assert_equal(true, has_reflection?(Tweet, :favs_count))
  end

  def test_eager_count_has_many_with_count_loader_does_not_execute_n_1_queries
    assert_queries(1 + tweets_count) { Tweet.all.map { |t| t.favorites.count } }
    assert_queries(1 + tweets_count) { Tweet.all.map(&:favorites_count) }
    assert_queries(1) { Tweet.eager_count(:favorites).map { |t| t.favorites.count } }
    assert_queries(1) { Tweet.eager_count(:favorites).map(&:favorites_count) }
  end

  def test_eager_count_has_many_counts_properly
    expected = Tweet.order(id: :asc).map { |t| t.favorites.count }
    assert_equal(expected, Tweet.order(id: :asc).map(&:favorites_count))
    assert_equal(expected, Tweet.order(id: :asc).eager_count(:favorites).map { |t| t.favorites.count })
    assert_equal(expected, Tweet.order(id: :asc).eager_count(:favorites).map(&:favorites_count))
  end

  def test_eager_count_has_many_with_scope_counts_properly
    expected = Tweet.order(id: :asc).map { |t| t.my_favs.count }
    assert_equal(expected, Tweet.order(id: :asc).eager_count(:my_favs).map { |t| t.my_favs.count })
    assert_equal(expected, Tweet.order(id: :asc).eager_count(:my_favs).map(&:my_favs_count))
  end

  def test_polymorphic_eager_count
    skip 'eager_count of polymorphic is not implemented yet'
    expected = Tweet.all.map { |t| t.notifications.count }
    assert_equal(expected, Tweet.eager_count(:notifications).map(&:notifications_count))
    assert_equal(expected, Tweet.eager_count(:notifications).map { |t| t.notifications.count })
  end
end
