require 'cases/helper'

class AutosaveAssociationBugReproductionTest < ActiveRecord::CountLoader::TestCase
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

  def test_bug_with_save_belongs_to_association_method_fixed
    tweet = Tweet.first
    tweet.my_favorites_count
    assert_equal(true, tweet.save!)
  end
end
