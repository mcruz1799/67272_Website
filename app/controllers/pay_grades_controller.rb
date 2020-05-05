class PayGradesController < ApplicationController
  before_action :set_pay_grade, only: [:edit, :update]
  before_action :check_login
  authorize_resource

  def new 
    @pay_grade = PayGrade.new
  end

  def create
    @pay_grade = PayGrade.new(pay_grade_params)
    if @pay_grade.save
      redirect_to pay_grades_path, notice: "Successfully added the pay grade."
    else
      render action: 'new'
    end
  end

  def edit 
  end

  def update
    if @pay_grade.update_attributes(pay_grade_params)
      redirect_to pay_grades_path, notice: "Updated #{@pay_grade.level}'s details."
    else
      render action: 'edit'
    end
  end

  def index
    @pay_grades = PayGrade.alphabetical
  end

  private 

  def set_pay_grade
    @pay_grade = PayGrade.find(params[:id])
  end

  def pay_grade_params
    params.require(:pay_grade).permit(:level, :active)
  end
end
