class Shop::OrdersController < ShopController
  custom_actions :resource => [:pay,:cancel]
  actions :all, except: [:update,:create,:destroy]

  def pay
    resource.pay
    redirect_to shop_orders_path
  end

  def cancel
    resource.shop_cancel
    redirect_to shop_orders_path
  end

  protected
  def collection
    @orders = super.index
  end
end

