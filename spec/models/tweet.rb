class Tweet < ActiveRecord::Base
  has_many :replies
  has_count :replies
end
