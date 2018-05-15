class Reservation < ActiveRecord::Base
  belongs_to :users
  belongs_to :boats

  validates_presence_of :start, :end, :recurring_instances
end
