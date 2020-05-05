module StoresHelper
  def get_shifts_for_date(date)
    dr = DateRange.new(date,date)
    @shifts.for_dates(dr)
  end
end
