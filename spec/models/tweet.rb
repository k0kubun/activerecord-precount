class Tweet < ActiveRecord::Base
  has_many :replies
end
