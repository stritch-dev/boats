class User < ActiveRecord::Base
  has_many :reservations
  has_many :boats, :through => :reservations

  validates_presence_of :email, :name

  has_secure_password
end
