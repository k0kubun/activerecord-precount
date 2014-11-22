class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :tweet_id
      t.integer :user_id

      t.timestamps
    end
  end
end
