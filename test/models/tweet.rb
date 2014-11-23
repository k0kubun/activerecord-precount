class Tweet < ActiveRecord::Base
  has_many :favorites
end
