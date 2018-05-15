class Boat < ActiveRecord::Base
  has_many :reservations
  has_many :users, :through => :user_reservations
end
