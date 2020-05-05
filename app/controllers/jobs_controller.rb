class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :check_login
  authorize_resource

  def show
    unless @job.shift_jobs.empty? 
      #TO DO: GET PAGINATION WORKING
      # @shifts = @job.shift_jobs.map{|sj| sj.shift}.select{|shift| shift.date >= 1.week.ago.to_date}.sort_by{|s| s.date}.paginate(page: params[:page]).per_page(10)
      @shifts = @job.shift_jobs.map{|sj| sj.shift}.select{|shift| shift.date >= 1.week.ago.to_date}.sort_by{|s| s.date}

    end
  end

  def index
    @jobs = Job.alphabetical
  end

  def new
    @job = Job.new
  end 

  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to @job, notice: "#{@job.name} was successfully added as a job in the system."
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @job.update_attributes(job_params)
      redirect_to @job, notice: "#{@job.name} was successfully updated in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @job.destroy
    flash[:notice] = "Successfully removed job from the system."
    redirect_to jobs_path
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:name, :description, :active)
  end
end
