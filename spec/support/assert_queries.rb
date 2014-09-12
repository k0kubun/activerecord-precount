# Copied from:
# https://github.com/rails/rails/blob/9bb76261d39b59e7e229c80d052ca91a65ff17be/activerecord/test/cases/test_case.rb#L40-L52
def expect_query_counts(num = 1, options = {})
  ignore_none = options.fetch(:ignore_none) { num == :any }
  SQLCounter.clear_log
  x = yield

  the_log = ignore_none ? SQLCounter.log_all : SQLCounter.log
  expect(the_log.size).to eq(num)

  x
end

class SQLCounter
  class << self
    attr_accessor :ignored_sql, :log, :log_all
    def clear_log; self.log = []; self.log_all = []; end
  end

  self.clear_log

  self.ignored_sql = [/^PRAGMA/, /^SELECT currval/, /^SELECT CAST/, /^SELECT @@IDENTITY/, /^SELECT @@ROWCOUNT/, /^SAVEPOINT/, /^ROLLBACK TO SAVEPOINT/, /^RELEASE SAVEPOINT/, /^SHOW max_identifier_length/, /^BEGIN/, /^COMMIT/]

  # FIXME: this needs to be refactored so specific database can add their own
  # ignored SQL, or better yet, use a different notification for the queries
  # instead examining the SQL content.
  oracle_ignored     = [/^select .*nextval/i, /^SAVEPOINT/, /^ROLLBACK TO/, /^\s*select .* from all_triggers/im, /^\s*select .* from all_constraints/im, /^\s*select .* from all_tab_cols/im]
  mysql_ignored      = [/^SHOW TABLES/i, /^SHOW FULL FIELDS/, /^SHOW CREATE TABLE /i]
  postgresql_ignored = [/^\s*select\b.*\bfrom\b.*pg_namespace\b/im, /^\s*select\b.*\battname\b.*\bfrom\b.*\bpg_attribute\b/im, /^SHOW search_path/i]
  sqlite3_ignored =    [/^\s*SELECT name\b.*\bFROM sqlite_master/im]

  [oracle_ignored, mysql_ignored, postgresql_ignored, sqlite3_ignored].each do |db_ignored_sql|
    ignored_sql.concat db_ignored_sql
  end

  attr_reader :ignore

  def initialize(ignore = Regexp.union(self.class.ignored_sql))
    @ignore = ignore
  end

  def call(name, start, finish, message_id, values)
    sql = values[:sql]

    # FIXME: this seems bad. we should probably have a better way to indicate
    # the query was cached
    return if 'CACHE' == values[:name]

    self.class.log_all << sql
    self.class.log << sql unless ignore =~ sql
  end
end

ActiveSupport::Notifications.subscribe('sql.active_record', SQLCounter.new)
