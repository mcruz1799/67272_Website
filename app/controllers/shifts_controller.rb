class ShiftsController < ApplicationController

  before_action :set_shift, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def index 
    @shifts = Shift.by_store
  end

  def show 
  end

  def new 
    @shift = Shift.new
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

  private 

  def set_shift
    @shift = Shift.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:date,:start_time,:end_time,:notes,:status)
  end
end
