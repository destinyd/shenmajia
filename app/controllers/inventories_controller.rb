class InventoriesController < InheritedResources::Base
  before_filter :could_modify? ,:only =>[:new,:update,:edit,:destroy]
  before_filter :authenticate_user!,:only =>[:new,:create,:update,:edit,:destroy]
  actions :all
  belongs_to :shop, :optional => true
  respond_to :html

  def create
   @shop ||= Shop.find(params[:shop_id])
	 @inventory = @shop.inventories.new(params[:inventory])
	 create!
  end

  def search

  end

  protected
  def collection
    @inventories ||= end_of_association_chain.paginate(:page => params[:page])
  end

  def could_modify?
    @shop = Shop.find(params[:shop_id])
  	if @shop.blank? or current_user.id != @shop.user_id
      redirect_to @shop
      return false
    end
  end
end
