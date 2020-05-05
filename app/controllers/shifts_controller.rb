class ShiftsController < ApplicationController

  before_action :set_shift, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def index 
    @upcoming_shifts = Shift.upcoming.chronological.paginate(page: params[:page]).per_page(10)
    @past_shifts = Shift.past.chronological.paginate(page: params[:page]).per_page(10)
  end

  def show 
    @employee = @shift.assignment.employee
    @store = @shift.assignment.store

    #add job form
    @shift_job = ShiftJob.new
    @job_array = Job.active.alphabetical.map{|job| [job.name, job.id]}

    #recorded jobs 
    @shift_jobs = @shift.shift_jobs.sort_by{|sj| sj.job.name}
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
    @shift = Shift.find(params[:shift_id])
    @shift_job.shift = @shift
    if @shift_job.save
      redirect_to @shift, notice: "Successfully added #{@shift_job.job.name} to the shift."
    else
      redirect_back(fallback_location: home_path) #, notice: "Job was not added to shift, please try again."
    end
  end

  def destroy_shift_job
    @shift_job = ShiftJob.find(params[:id])
    @shift_job.destroy
    redirect_back(fallback_location: home_path)
  end

  private 

  def set_shift
    @shift = Shift.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:assignment_id,:date,:start_time,:end_time,:notes,:status)
  end

  def shift_job_params
    params.require(:shift_job).permit(:shift_id,:job_id)
  end
end
