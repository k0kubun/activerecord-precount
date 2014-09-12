class Tweet < ActiveRecord::Base
  has_many :replies
  count_preloadable :replies
end
