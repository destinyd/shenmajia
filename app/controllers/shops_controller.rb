class ShopsController < InheritedResources::Base
  layout 'userhome',only: [:edit]
  before_filter :authenticate_user!,only: [:new,:create,:update,:edit,:destroy]
  actions :all,except: [:new,:create,:destroy]
  belongs_to :city,finder: :find_by_name!, optional: true
  belongs_to :brand, optional: true
  respond_to :html
  respond_to :js,only: :places_search

  def edit
    @shop = current_user.shops.find params[:id]
    edit!
  end

  def update
    @shop = current_user.shops.find params[:id]
    update!{'/shop'}
  end  

  # def create
  #    @shop = current_user.shops.new(params[:shop])
  #    create!
  # end
  def places_search

  end
  protected
  def collection
    @shops ||= end_of_association_chain.paginate(page: params[:page])
  end
end
