class PayrollController < ApplicationController

  def generate_store_report
    date_range = DateRange.new(date_range_params)
    store = params[:id]
    calc = PayRollCalculator.new(date_range)
    report = PayRollCalculator.create_payrolls_for(store)
  end

  def generate_employee_report(date_range)
    
  end

  private 

  def date_range_params 
    params.require(:date_range).permit(:start_date, :end_date)
  end
end
