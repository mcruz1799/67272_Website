module EmployeesHelper
  def number_to_ssn(num)
    "#{num[0..2]}-#{num[3..4]}-#{num[5..8]}"
  end

  def get_shifts_for_date(date)
    dr = DateRange.new(date,date)
    @shifts.for_dates(dr)
  end
end
