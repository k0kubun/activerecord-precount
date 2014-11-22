[Tweet, Favorite, User].map(&:delete_all)

(1..5).each do |count|
  user  = User.create
  tweet = Tweet.create(user: user)

  count.times do
    user = User.create
    Favorite.create(tweet: tweet, user: user)
    Tweet.create(tweet: tweet, user: user)
  end
end
