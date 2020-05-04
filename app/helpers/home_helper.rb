module HomeHelper

  def punch_in? 
    employee = current_user
    Shift.pending.for_employee(@employee).for_next_days(0).first.nil? ? false : true
  end

  def punch_out? 
    employee = current_user
    Shift.started.for_employee(@employee).for_next_days(0).first.nil? ? false : true
  end
end