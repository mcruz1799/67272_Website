class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def show
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
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:name, :description, :active)
  end
end
