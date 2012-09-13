class Userhome::OrdersController < UserhomeController
  defaults :resource_class => Bill, :collection_name => 'bills', :instance_name => 'bill'
  actions :all#, except: [:update]
  def update
    current_shop.bills.find(params[:id]).pay
    redirect_to userhome_orders_path
  end
  protected
  def begin_of_association_chain
    current_shop
  end
end
