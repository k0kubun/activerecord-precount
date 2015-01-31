# ActiveRecord::Precount [![Build Status](https://travis-ci.org/k0kubun/activerecord-precount.svg?branch=master)](https://travis-ci.org/k0kubun/activerecord-precount)

N+1 count query killer for ActiveRecord. Yet another counter\_cache alternative.  
ActiveRecord::Precount allows you to cache count of associated records by eager loading.

## Synopsis

### N+1 count query

Sometimes you may see many count queries for one association.
You can use counter\_cache to solve it, but it costs much to use counter\_cache.

```rb
Tweet.all.each do |tweet|
  p tweet.favorites.count
end
# SELECT `tweets`.* FROM `tweets`
# SELECT COUNT(*) FROM `tweets` WHERE `tweets`.`tweet_id` = 1
# SELECT COUNT(*) FROM `tweets` WHERE `tweets`.`tweet_id` = 2
# SELECT COUNT(*) FROM `tweets` WHERE `tweets`.`tweet_id` = 3
# SELECT COUNT(*) FROM `tweets` WHERE `tweets`.`tweet_id` = 4
# SELECT COUNT(*) FROM `tweets` WHERE `tweets`.`tweet_id` = 5
```

### Count eager loading

With activerecord-precount gem installed, you can use `precount` method
to eagerly load counts of associated records.

```rb
Tweet.all.precount(:favorites).each do |tweet|
  p tweet.favorites.count
end
# SELECT `tweets`.* FROM `tweets`
# SELECT `tweets`.`in_reply_to_tweet_id` FROM `tweets` WHERE `tweets`.`tweet_id` IN (1, 2, 3, 4, 5)
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-precount'
```

## Supported Versions

- Ruby
  - 2.0, 2.1, 2.2
- Rails
  - 4.1, 4.2
- Databases
  - sqlite
  - mysql
  - postgresql

## Testing

```bash
$ bundle exec rake
```

## Contributing

1. Fork it ( https://github.com/k0kubun/activerecord-precount/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
