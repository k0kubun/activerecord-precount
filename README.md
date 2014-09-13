# ActiveRecord::HasCount [![Build Status](https://travis-ci.org/k0kubun/activerecord-has_count.png?branch=master)](https://travis-ci.org/k0kubun/activerecord-has_count)

N+1 count query killer for ActiveRecord  
ActiveRecord::HasCount allows you to cache count of associated records by eager loading

## Why ActiveRecord::HasCount?
Rails provides a way to resolve N+1 count query, which is [belongs\_to's counter\_cache option](http://guides.rubyonrails.org/association_basics.html#counter-cache).  
It requires a column to cache the count. But adding a column just for count cache is overkill.  
  
Thus this plugin enables you to preload counts in the same way as `has_many` and `belongs_to`.  
`has_count` is an ActiveRecord's association, which is preloadable by `preload` or `includes`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-has_count'
```

## Usage

### Add count\_preloadable scope
First, call `has_count` with an association whose count you want to preload

```rb
class Tweet
  has_many :replies
  has_count :replies # defines association named :replies_count
end
```

The option creates an additional association whose name is `replies_count`.  
Its association type is not an ordinary one (i.e. `has_many`, `belongs_to`) but `has_count`.

### Preload the association
This association works well by default.

```rb
@tweets = Tweet.all
@tweets.each do |tweet|
  p tweets.replies_count # same as tweets.replies.count
end
```

You can eagerly load `has_count` association by `includes` or `preload`.

```rb
@tweets = Tweet.preload(:replies_count)
@tweets.each do |tweet|
  p tweets.replies_count # this line doesn't execute an additional query
end
```

Since it is association, you can preload nested `has_count` association.

```rb
@favorites = Favorite.preload(tweet: :replies_count)
@favorites.each do |favorite|
  p favorite.tweet.replies_count # this line doesn't execute an additional query
end
```

## Contributing

1. Fork it ( https://github.com/k0kubun/activerecord-has_count/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
