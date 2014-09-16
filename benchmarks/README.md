# N+1 COUNT query benchmarks

## Preparation

```bash
$ git clone git@github.com:k0kubun/activerecord-has_count
$ cd activerecord-has_count
$ mysql -uroot -e"create database bench"
$ bundle install
```

## Run

```bash
$ bundle exec ruby benchmark.rb
```
