class Shop::OrdersController < ShopController
  custom_actions :resource => [:pay,:cancel]
  actions :all, except: [:update,:create,:destroy]

  def pay
    if resource.pay
      redirect_to shop_orders_path
    else
      redirect_to :back,error: resource.errors.messages[:status].join
    end
  end

  def cancel
    if resource.shop_cancel
      redirect_to shop_orders_path
    else
      redirect_to :back,error: resource.errors.messages[:status].join
    end
  end

  protected
  def collection
    @orders = super.index
  end
end

