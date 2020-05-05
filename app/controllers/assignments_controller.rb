class AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:show, :edit, :terminate, :destroy]
  before_action :check_login
  authorize_resource

  def index
    if current_user.role? :admin
      @current_assignments = Assignment.current.chronological.paginate(page: params[:page]).per_page(10)
      @past_assignments = Assignment.past.chronological.paginate(page: params[:page]).per_page(10)
    elsif current_user.role? :manager
      @current_assignments = Assignment.current.for_store(current_user.current_assignment).chronological.paginate(page: params[:page]).per_page(10)
      @past_assignments = Assignment.past.for_store(current_user.current_assignment).chronological.paginate(page: params[:page]).per_page(10)
      @store = current_user.current_assignment.store
    elsif current_user.role? :employee
      @current_assignments = Assignment.current.for_employee(current_user).paginate(page: params[:page]).per_page(10)
      @past_assignments    = Assignment.past.for_employee(current_user).chronological.paginate(page: params[:page]).per_page(10)
    end
    

  end

  def new
    @assignment = Assignment.new
    @assignment.employee_id = params[:employee_id] unless params[:employee_id].nil?
    @assignment.start_date = Date.current
  end

  def create
    @assignment = Assignment.new(assignment_params)
    if @assignment.save
      redirect_to employee_path(@assignment.employee), notice: "Successfully added the assignment."
    else
      render action: 'new'
    end
  end

  def terminate
    if @assignment.terminate
      redirect_to assignments_path, notice: "Assignment for #{@assignment.employee.proper_name} terminated."
    end
  end

  def destroy
    @assignment.destroy
    redirect_to assignments_path, notice: "Removed assignment from the system."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_assignment
    @assignment = Assignment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def assignment_params
    params.require(:assignment).permit(:store_id, :employee_id, :pay_grade_id, :start_date)
  end

end

