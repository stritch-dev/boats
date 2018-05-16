# Reservation represents a reservation that a user 
# has for a boat on a specific day at a specific time for a defined period
class CreateReservation < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      t.belongs_to :user, index: true
      t.belongs_to :boat, index: true
      t.datetime :start_time
      t.datetime :end_time
      t.integer :recurring_instances
    end
  end
end
