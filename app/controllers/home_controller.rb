class HomeController < ApplicationController
  def index
    @stores = Store.all.alphabetical
    @shift = todays_shift if current_user.role? :employee
    # @store_array = store.map{|store| [store.name, store.id] }
  end

  def generate_payroll_report
    date_range = DateRange.new(date_range_params)
    store = params[:store]
    calc = PayRollCalculator.new(date_range)
    report = PayRollCalculator.create_payrolls_for(store)
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