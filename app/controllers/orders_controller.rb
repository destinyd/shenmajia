class OrdersController < InheritedResources::Base
  layout 'userhome',only: [:index,:show]
  before_filter :authenticate_user!,only: [:new,:create]
  actions :all, except: [:edit,:update,:destroy]
  #belongs_to :place, optional: true
  # belongs_to :shop, optional: true
  respond_to :html

  respond_to :js, only: [:index, :new]

  def create
    @order = current_user.orders.new params[:order]
    items = session[:shop][:items]
    return redirect_to userhome_orders_path if items.nil? or items.keys.length ==0
    inventories = Inventory.find(items.keys)
    inventories.each do |inventory|
      order_price = @order.order_prices.new amount: items[inventory.id.to_s][:amount]
      order_price.price_id = inventory.price_id
    end
    if create!{|success,failure| success.html}
      session[:shop] = {}
      @shop = @order.shop
      Msg.delay.create({to:@shop.user_id,title:t('msg.order.new.title'),body: t('msg.order.new.body',order:@order),to_name: @shop.user.username},on: :admin)
    end
  end

  def collection
    @orders = collection ||= end_of_association_chain.recent.paginate(page: params[:page]).index
  end
end

