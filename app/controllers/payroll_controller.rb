class PayrollController < ApplicationController

  def store_report
    # start_date  = params[:start_date]
    # end_date    = params[:end_date]
    # store       = Store.find(params[:store_id])
    # date_range = DateRange.new(start_date, end_date)
    # calc = PayRollCalculator.new(date_range)
    # @report = PayRollCalculator.create_payrolls_for(store)
  end

  def employee_report
    
  end

  private 

  def payroll_params
    params.require(:payroll).permit(:date_range)
  end
  # def date_range_params 
  #   params.require(:date_range).permit(:start_date, :end_date)
  # end
end
