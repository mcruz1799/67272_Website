class HomeController < ApplicationController
  def index
    @stores = Store.all.alphabetical
    # @store_array = store.map{|store| [store.name, store.id] }
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