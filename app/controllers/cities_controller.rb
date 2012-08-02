class CitiesController < ApplicationController
  layout 'home'

  caches_page :index, :show
  #caches_action :show,
    #:expires_in => 2.hours

  def index
  end

  def show
    @name = params[:id]
    @city = City.find_by_name @name 
    @prices= @city.prices.recent.running.with_good.paginate( :page => params[:page]).limit(100)
    #@value = @city.lat,@city.lon
    #@cheapest = Price.cheapest.near(@value,20).limit(10)
    #@recent_prices =     Price.recent.near(@value,20).limit(10)
    #@recent_groupbuy =     Price.groupbuy.near(@value,20).limit(10)
    #@recent_cost =     Price.costs.near(@value,20).limit(10)
    #@recent_nearest =     Price.near(@value,20).nearest.limit(10)
    #@recent_goods = Good.recent.group(:name).limit(10)
  end

end
