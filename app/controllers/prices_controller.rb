class PricesController < InheritedResources::Base
  before_filter :authenticate_user!, only: [:new,:create,:edit,:update,:destroy]
  respond_to :html
  respond_to :js, only: :create
  belongs_to :city, finder: :find_by_name, optional: true
  belongs_to :good, optional: true
  belongs_to :place, optional: true

  #caches_page :index, :show#, :groupbuy, :cheapest#, :near_cheapest, :near_groupbuy, :cheap
  #cache_sweeper :price_sweeper

  #def groupbuy
    #@prices = collection
    #render action: "index"
  #end

  #def buy_one
    #price = Price.find(params[:id])
    #@price = current_user.prices.new type_id: 0,
      #price: price.price,
      #address: price.address,
      #lat: price.lat,
      #lon: price.lon
    #@price.good_id = price.good_id
    #@price.save
    #redirect_to @price
  #end

  #def near_groupbuy

  #end

  #def near_cheapest

  #end

  def cheapest
    @prices = collection
    render action: "index"
  end

  #def cheap
  #end

  #def create
    #create! do |format|
      #format.js{render :create}
      #format.html {redirect_to @price}
    #end
  #end


  protected
  def collection
    @prices ||= end_of_association_chain.in_action(action_name).list.page(params[:page])
    #@prices = @prices.send action_name if %w{cheapest groupbuy}.include? action_name
    #@prices = @prices.recent.page(params[:page])
    #@prices ||=  end_of_association_chain.recent.page(params[:page])
  end
  #private
  #def find_able_and_prices
    #@prices = Price
    #params.each do |name, value|
      #if name =~ /(.+)_id$/
        #if $1 == 'city'
          #@able = $1.classify.constantize.where(name: value).first
          #loc = @able.lat,@able.lon
        #elsif $1 == 'locate'
          #@able = $1.classify.constantize.where(name: value).first
          #@able = Locate.create(name: value) unless @able
          #loc = @able.lat,@able.lon
        #else
          #@able = $1.classify.constantize.find(value) 
          #@prices = @able.prices
        #end 
      #@prices = @prices.send action_name if ['cheapest','groupbuy','costs'].include? action_name
      #@prices = @prices.recent if action_name == 'index'
      #@prices = @prices.near(loc,20) if $1 == 'city' or $1 == 'locate'
      #return @prices#with_uploads
      #end  
    #end  
    #@prices = Price.send action_name if ['cheapest','groupbuy','costs'].include? action_name
    #@prices = Price.recent if action_name == 'index'
    #@prices = @prices#.with_uploads
  #end
end
