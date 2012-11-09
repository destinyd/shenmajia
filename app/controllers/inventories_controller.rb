class InventoriesController < InheritedResources::Base
  layout 'no_sidebar'
  before_filter :could_modify? ,only: [:new,:update,:edit,:destroy]
  before_filter :authenticate_user!,only: [:new,:create,:update,:edit,:destroy]
  before_filter :redirect_to!,only: [:index,:show]
  actions :all
  belongs_to :shop, optional: true
  respond_to :html
  respond_to :js, only: [:tuijian]

  def create
   @inventory = current_shop.inventories.new(params[:inventory])
   create!{shop_inventories_path}
  end

  def update
   update!{shop_inventories_path}
  end

  def search

  end

  def tuijian
    
  end

  protected
  def collection
    @inventories ||= end_of_association_chain.paginate(page: params[:page])
  end

  def could_modify?
    @shop = Shop.find(params[:shop_id])
  	if @shop.blank? or current_user.id != @shop.user_id
      redirect_to @shop
      return false
    end
  end

  def redirect_to!
    if params[:shop_id].blank?
      @inventory = Inventory.find(params[:id])
      redirect_to shop_inventory_path(@inventory.shop,@inventory)
    end
  end

end
