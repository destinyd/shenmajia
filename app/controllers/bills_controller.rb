class BillsController < InheritedResources::Base
  before_filter :authenticate_user!,only: [:new,:create]
  actions :all, except: [:edit,:update,:destroy]
  belongs_to :place, optional: true
  # belongs_to :shop, optional: true
  respond_to :html

  respond_to :js, only: [:index, :new]

  caches_page :index,:show
  cache_sweeper :bill_sweeper

  def create
    @bill = current_user.bills.new params[:bill]
    if params[:shop_id]
      @shop = Shop.find params[:shop_id]
      @bill.locatable = @shop
      @bill.shop_id = @shop.id
      items = session[:shop][:items]
      inventories = Inventory.find(items.keys)
      inventories.each do |inventory|
        bp = @bill.bill_prices.new amount: items[inventory.id.to_s][:amount]
        bp.price_id = inventory.price_id
      end
      session[:shop] = {} if create!
    else
      @bill.locatable = Place.find(session[:cart][:place_id])
      session[:cart][:items].each do |key,item|
        bp = @bill.bill_prices.new
        bp.amount = item[:amount]
        bp.price = Price.where(
          locatable_type: 'Place',
          locatable_id: session[:cart][:place_id],
          good_id: key,
          price: item[:price],
          lat: @bill.locatable.lat,
          lon: @bill.locatable.lon,
          city_id: @bill.locatable.city_id
          ).first_or_create({type_id: 0,user_id: @bill.user_id}, on: :bill)
      end
      session[:cart] = {} if create!      
    end
  end

  def collection
    @bills = collection ||= end_of_association_chain.recent.paginate(page: params[:page])
  end
end