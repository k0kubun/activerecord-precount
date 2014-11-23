class Tweet < ActiveRecord::Base
  has_many :favorites, count_loader: true
end
