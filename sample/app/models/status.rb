class Status < ActiveRecord::Base
  has_many :replies, class_name: 'Tweet'
  has_count :replies, class_name: 'Tweet'
end
