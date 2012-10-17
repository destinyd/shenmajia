class Userhome::OrdersController < UserhomeController
  custom_actions :resource => [:user_cancel,:receive]
  actions :all, except: [:update,:create,:destroy]

  def receive
    if resource.receive
      redirect_to userhome_orders_path
    else
      redirect_to :back,alert: resource.errors.messages[:status].join
    end
  end

  def cancel
    if resource.user_cancel
      redirect_to userhome_orders_path
    else
      redirect_to :back,alert: resource.errors.messages[:status].join
    end
  end

  protected
  def collection
    @orders = super.index
  end
end
