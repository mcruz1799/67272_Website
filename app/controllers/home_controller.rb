class HomeController < ApplicationController
  def index
    @stores = Store.all.alphabetical
    if logged_in? && (current_user.role? :employee)
      setup_latest_pay_report
      setup_latest_shifts

    end
    # @store_array = store.map{|store| [store.name, store.id] }
  end

  def punch_clock
    if punch_in?
      tc = TimeClock.new(todays_shift)
      tc.start_shift_at()
      redirect_to home_path, notice: "Successfully clocked in."
    elsif punch_out?
      tc = TimeClock.new(todays_shift)
      tc.end_shift_at()
      redirect_to home_path, notice: "Successfully clocked out."
    end
  end

  def about
  end

  def contact
  end

  def privacy
  end

  private 

  def date_range_params 
    params.require(:date_range).permit(:start_date, :end_date)
  end

  def setup_latest_shifts
    params[:start_date] = 1.week.ago.to_date #for simple calendar to show +/- 1 week
    @employee = current_user
    @shifts = Shift.for_employee(@employee).chronological
  end

  def setup_latest_pay_report
    @shift = todays_shift
    start_date = 8.days.ago.to_date
    date_range = DateRange.new(start_date)
    @calc = PayrollCalculator.new(date_range)
    @payroll = @calc.create_payroll_record_for(current_user)
  end

  def todays_shift
    employee = current_user
    shift = Shift.pending.for_employee(employee).for_next_days(0).first
    shift ||= Shift.started.for_employee(employee).for_next_days(0).first
    return shift
  end
  
  def punch_in? 
    Shift.pending.map(&:id).include?(todays_shift.id)
  end

  def punch_out? 
    Shift.started.map(&:id).include?(todays_shift.id)
  end
end