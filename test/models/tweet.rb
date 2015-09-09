class Tweet < ActiveRecord::Base
  has_many :favorites, count_loader: true
  has_many :favs, class_name: 'Favorite'
  has_many :my_favorites, -> { where(user_id: 1) }, class_name: 'Favorite', count_loader: true
  has_many :my_favs, -> { where(user_id: 1) }, class_name: 'Favorite'
end
