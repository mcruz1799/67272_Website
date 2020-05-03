class PayGradeRatesController < ApplicationController

  def index 
    @pay_grades = PayGrade.alphabetical
    @pay_grade_rates = PayGradeRate.chronological
  end

  def new 
    @pay_grade_rate = PayGradeRate.new
  end

  def create
    @pay_grade_rate = PayGradeRate.new(pay_grade_rate_params)
    if @pay_grade_rate.save
      redirect_to pay_grade_rates_path, notice: "Successfully added the pay grade rate to #{@pay_grade_rate.pay_grade.level}"
    else
      render action: 'new'
    end
  end

  private 

  def pay_grade_rate_params
    params.require(:pay_grade_rate).permit(:pay_grade_id, :rate, :start_date, :end_date)
  end
end
