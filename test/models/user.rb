class User < ActiveRecord::Base
  has_many :tweets
  has_many :favorites, through: :tweets
end
