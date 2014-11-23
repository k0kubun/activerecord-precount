require 'cases/helper'
require 'models/favorite'
require 'models/tweet'

class EagerLoadTest < ActiveRecord::CountLoader::TestCase
  def setup
    tweet = Tweet.create
    Favorite.create(tweet: tweet)
  end

  def teardown
    [Tweet, Favorite].each(&:delete_all)
  end

  def test_eager_loaded_count_loader_raises_an_error
    assert_raises ActiveRecord::EagerLoadCountLoaderError do
      Tweet.eager_load(:favorites_count).to_a
    end
  end
end
