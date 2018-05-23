class Reservation < ActiveRecord::Base

  belongs_to :users
  belongs_to :boats

  validates_presence_of :start_time, :end_time, :recurring_instances

  validate :start_preceeds_end?, :reservation_period_conflict_free?, :acceptable_duration?

  
  
  def start_preceeds_end?
    if end_time <= start_time
      errors.add(:start_time, "#{start_time} must be before end time #{end_time}")
    end
  end
  
  # TODO prevent user from making reservation twice for same boat and time period
  def reservation_period_conflict_free?
    boat_reservations = Reservation.all.select do |reservation| 
      reservation.boat_id = self.boat_id
    end

    if boat_reservations.empty?
      true
    else
      boat_reservations.each do |reservation|
        if start_time >= reservation.start_time && start_time <=reservation.end_time
          errors.add(:start_time, "cannot fall within existing reservation time slot")
        elsif end_time >= reservation.start_time && end_time <=reservation.end_time
          errors.add(:end_time, "cannot fall within existing reservation time slot")
        elsif start_time <= reservation.start_time && end_time >= reservation.end_time
          errors.add(:end_time, "cannot overtake existing reservation time slot")
        end
      end
    end
  end

  # TODO move max_duration to a configuration file/module
  def acceptable_duration?
    max = 60*60*24 #  one day
    if end_time - start_time > 60*60*24 #  one day
      # TODO this is not just :end_time
      errors.add(:end_time , "duration #{end_time - start_time} exceeds max of #{max}")
    else
      true
    end
  end

  def boat
    Boat.find self.boat_id
  end

  def user
    User.find self.user_id
  end

end
