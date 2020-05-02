module SchedulesHelper

  def get_shifts_for_day(date)
    dr = DateRange.new(date,date)
    Shift.for_dates(dr).chronological
  end
    
end
