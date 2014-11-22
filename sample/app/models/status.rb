class Status < ActiveRecord::Base
  has_many :replies, class_name: 'Tweet'
  count_loader :replies, class_name: 'Tweet'
end
