class SchedulesController < ApplicationController

  def schedule 
    if logged_in? 
      if current_user.role? :admin
        get_admin_schedule
      elsif current_user.role? :manager
        get_manager_schedule
      else
        get_employee_schedule
      end
    end
  end

  private 

  def get_admin_schedule
    if params[:id].present? 
      store = Store.find(params[:id])
    else
      store = Store.first
    end
    @shifts = Shift.for_store(store)
  end

  def get_manager_schedule 
    store = current_user.current_assignment.store
    @shifts = Shift.for_store(store)
  end

  def get_employee_schedule
    @shifts = Shift.for_employee(current_user)
  end
end
