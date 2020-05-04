class PayrollController < ApplicationController

  def store_report
    puts params[:date_range]
    start_date  = params[:date_range][:start_date].to_date
    end_date    = params[:date_range][:end_date].to_date
    store       = Store.find(params[:date_range][:store_id])
    date_range = DateRange.new(start_date, end_date)
    calc = PayrollCalculator.new(date_range)
    @report = calc.create_payrolls_for(store)
  end

  def employee_report
    
  end

  private 

  #TO DO: WHITELIST
  # def date_range_params 
  #   params.require(:date_range).permit(:start_date, :end_date)
  # end
end
