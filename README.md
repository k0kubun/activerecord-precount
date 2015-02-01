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

#### precount

With activerecord-precount gem installed, you can use `precount` method
to eagerly load counts of associated records.
Like `preload`, it loads counts by multiple queries

```rb
Tweet.all.precount(:favorites).each do |tweet|
  p tweet.favorites.count
end
# SELECT `tweets`.* FROM `tweets`
# SELECT COUNT(`favorites`.`tweet_id`), `favorites`.`tweet_id` FROM `favorites` WHERE `favorites`.`tweet_id` IN (1, 2, 3, 4, 5) GROUP BY `favorites`.`tweet_id`
```

#### eager\_count

Like `eager_load`, `eager_count` method allows you to load counts by one JOIN query.

```rb
Tweet.all.eager_count(:favorites).each do |tweet|
  p tweet.favorites.count
end
# SELECT `tweets`.`id` AS t0_r0, `tweets`.`tweet_id` AS t0_r1, `tweets`.`user_id` AS t0_r2, `tweets`.`created_at` AS t0_r3, `tweets`.`updated_at` AS t0_r4, COUNT(`favorites`.`id`) AS t1_r0 FROM `tweets` LEFT OUTER JOIN `favorites` ON `favorites`.`tweet_id` = `tweets`.`id` GROUP BY tweets.id
```

## Benchmark

The [result](https://travis-ci.org/k0kubun/activerecord-precount/jobs/49061937) of
[this benchmark](https://github.com/k0kubun/activerecord-precount/blob/40765d36ff0e0627cd0941b2c0a0f6573290c67e/benchmark.rb).

|    | N+1 query | precount | eager\_count |
|:-- |:----------|:---------|:-------------|
| Time | 1.401 | 0.176 | 0.119 |
| Ratio | 1.0x | **7.9x faster** | **11.7x faster** |

```rb
# Tweet count is 50, and each tweet has 10 favorites
Tweet.all.map{ |t| t.favorites.count }                # N+1 query
Tweet.precount(:favorites).map(&:favorites_count)     # precount
Tweet.eager_count(:favorites).map(&:favorites_count)  # eager_count
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
`Foo.precount(:bars)` or `Foo.eager_count(:bars)` automatically defines `bars_count` association for `Foo`.
That enables you to preload the association and call `foo.bars_count`.

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
Foo.eager_count(:bars).map { |f| f.bars.count }

# fast (recommended)
Foo.precount(:bars).map { |f| f.bars_count }
Foo.eager_count(:bars).map { |f| f.bars_count }
```

## License

MIT License
