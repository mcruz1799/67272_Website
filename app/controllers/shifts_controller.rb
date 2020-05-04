class ShiftsController < ApplicationController

  before_action :set_shift, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def index 
    @upcoming_shifts = Shift.upcoming.chronological.paginate(page: params[:page]).per_page(10)
    @past_shifts = Shift.past.chronological.paginate(page: params[:page]).per_page(10)
  end

  def show 
    @employee = @shift.assignment.employee
    @store = @shift.assignment.store
    @shift_job = ShiftJob.new
  end

  def new 
    @shift = Shift.new
    @assignments = Assignment.current.map{|a| a.employee}
    @shift.assignment_id = params[:assignment_id] unless params[:assignment_id].nil?

  end 

  def create
    @shift = Shift.new(shift_params)
    if @shift.save
      redirect_to @shift, notice: "Successfully created a shift for #{@shift.employee.name} at #{@shift.store.name}"
    else
      render action: 'new'
    end
  end

  def edit 
  end

  def update
    if @shift.update_attributes(shift_params)
      redirect_to @shift, notice: "Updated #{@shift.employee.name}'s shift at #{@shift.store.name}."
    else
      render action: 'edit'
    end
  end

  def create_shift_job
    @shift_job = ShiftJob.new(shift_job_params)
    @shift_job.shift_id = @shift.id
    if @shift_job.save
      redirect_to @shift, notice: "Successfully added #{@shift_job.job.name} to the shift."
    else
      redirect_back(fallback_location: home_path) #, notice: "Job was not added to shift, please try again."
    end
  end

  private 

  def set_shift
    @shift = Shift.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:assignment_id,:date,:start_time,:end_time,:notes,:status)
  end

  def shift_job_params
    params.permit(:shift_id,:job_id)
  end
end
