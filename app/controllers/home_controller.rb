class HomeController < ApplicationController
  def index
    @stores = Store.all.alphabetical
    # @store_array = store.map{|store| [store.name, store.id] }
  end

  def generate_payroll
    date_range = DateRange.new(date_range_params)
    store = params[:store]
    calc = PayRollCalculator.new(date_range)
    report = PayRollCalculator.create_payrolls_for(store)
  end

  def about
  end

  def contact
  end

  def privacy
  end

  private 

  def date_range_params 
    params.require(:date_range).permit(:start_date, :end_date)
  end
  
end