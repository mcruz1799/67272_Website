class HomeController < ApplicationController
  def index
    @stores = Store.all.alphabetical
    if logged_in?
      # flash[:notice] = "Welcome #{current_user.first_name}!"
      if current_user.role? :employee
        setup_latest_pay_report
        setup_latest_shifts
      elsif current_user.role? :manager
        get_managers_store
        get_managers_employees
        get_managers_shifts
      end

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

  def get_managers_shifts
    @shifts = Shift.for_store(@store).for_next_days(7).chronological unless @store.nil? 
  end

  def get_managers_employees
    @employees = Assignment.current.for_store(@store).map{|a|a.employee}.sort_by{|e|e.name} unless @store.nil?
  end

  def get_managers_store 
    @store = current_user.current_assignment.store unless current_user.current_assignment.nil?
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