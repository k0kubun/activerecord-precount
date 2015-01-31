class Tweet < ActiveRecord::Base
  has_many :favorites, count_loader: true
  has_many :favs, class_name: 'Favorite'
end
