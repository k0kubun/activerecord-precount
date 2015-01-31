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
# SELECT COUNT(*) FROM `favorites` WHERE `favorites`.`tweet_id` = 1
# SELECT COUNT(*) FROM `favorites` WHERE `favorites`.`tweet_id` = 2
# SELECT COUNT(*) FROM `favorites` WHERE `favorites`.`tweet_id` = 3
# SELECT COUNT(*) FROM `favorites` WHERE `favorites`.`tweet_id` = 4
# SELECT COUNT(*) FROM `favorites` WHERE `favorites`.`tweet_id` = 5
```

### Count eager loading

With activerecord-precount gem installed, you can use `precount` method
to eagerly load counts of associated records.

```rb
Tweet.all.precount(:favorites).each do |tweet|
  p tweet.favorites.count
end
# SELECT `tweets`.* FROM `tweets`
# SELECT COUNT(`favorites`.`tweet_id`), `favorites`.`tweet_id` FROM `favorites` WHERE `favorites`.`tweet_id` IN (1, 2, 3, 4, 5) GROUP BY `favorites`.`tweet_id`
```

## Benchmark

With [this benchmark](https://github.com/k0kubun/activerecord-precount/blob/079c8fdaaca4e7f08f542f825e296183a3f19c67/benchmark.rb)
([result](https://travis-ci.org/k0kubun/activerecord-precount/jobs/48996451)),
precounted query is **7.7x faster** than N+1 count query.

```rb
# Tweet count is 50, and each tweet has 10 favorites
Tweet.precount(:favorites).first(50).map(&:favorites_count) # 0.190
Tweet.first(50).map{ |t| t.favorites.count }                # 1.472
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

## Advanced Usage

### Nested eager loading
`Foo.precount(:bars)` automatically defines `bars_count` association for `Foo`.
Thus you can preload the association and call `foo.bars_count`.

You can manually define `bars_count` with follwoing code.

```diff
 class Foo < ActiveRecord::Base
-  has_many :bars
+  has_many :bars, count_loader: true
 end
```

Then there are two different ways to preload the `bars_count`.

```rb
# the same
Foo.preload(:bars_count)
Foo.precount(:bars)
```

With this condition, you can eagerly load nested association by preload.

```rb
Hoge.preload(foo: :bars_count)
```

### Performance issue

With activerecord-precount gem installed, `bars.count` fallbacks to `bars_count` if `bars_count` is defined.
Though precounted `bars.count` is faster than not-precounted one, the fallback is currently much slower than just calling `bars_count`.

```rb
# slow
Foo.precount(:bars).map { |f| f.bars.count }

# fast (recommended)
Foo.precount(:bars).map { |f| f.bars_count }
```

## License

MIT License
