class Userhome::OrdersController < UserhomeController
  custom_actions :resource => [:user_cancel,:receive]
  actions :all, except: [:update,:create,:destroy]

  def receive
    resource.receive
    redirect_to userhome_orders_path
  end

  def cancel
    resource.user_cancel
    redirect_to userhome_orders_path
  end

  protected
  def collection
    @orders = super.index
  end
end
