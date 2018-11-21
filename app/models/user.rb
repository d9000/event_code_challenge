class User < ApplicationRecord
  has_many :events, class_name: 'Event'
  validates_presence_of :username, message: 'Invalid, username cannot be blank'
end
