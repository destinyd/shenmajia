class BillsController < InheritedResources::Base
  layout 'no_sidebar',only: [:new,:create]
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
    return redirect_to(new_bill_path,error:t('error.fault')) if params[:place_id].blank? or session[:cart].blank? or session[:cart][:items].blank?
    #if params[:shop_id]
      #@shop = Shop.find params[:shop_id]
      #@bill.locatable = @shop
      #@bill.shop_id = @shop.id
      #items = session[:shop][:items]
      #inventories = Inventory.find(items.keys)
      #inventories.each do |inventory|
        #bp = @bill.bill_prices.new amount: items[inventory.id.to_s][:amount]
        #bp.price_id = inventory.price_id
      #end
      #if create!{|success,failure| success.html}
        #session[:shop] = {}
        #Msg.delay.create({to:@shop.user_id,title:t('msg.bill.new.title'),body: t('msg.bill.new.body',bill:@bill),to_name: @shop.user.username},on: :admin)
      #end
    #else
      @bill.locatable = @place = Place.find(params[:place_id])
      session[:cart][:items].each do |key,item|
        bp = @bill.bill_prices.new
        bp.amount = item[:amount]
        unless params[:image].blank?
          bp.image = params[:image][key]
          @bill.picture_count +=1 unless params[:image][key].blank?
        end
        bp.price = Price.where(
          locatable_type: 'Place',
          locatable_id: params[:place_id],
          good_id: key,
          price: item[:price],
          lat: @bill.locatable.lat,
          lon: @bill.locatable.lon,
          city_id: @bill.locatable.city_id
          ).first_or_create({type_id: 0,user_id: @bill.user_id}, on: :bill)
      end
      create!{|success,failure| 
        success.html{
          session[:cart] = {}
        }
        failure.html{
          render :new
        }
      }
    #end
  end

  def collection
    @bills = collection ||= end_of_association_chain.recent.list.paginate(page: params[:page])
  end
end
