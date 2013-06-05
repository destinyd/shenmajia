class ShopController < InheritedResources::Base
  layout 'userhome'# ,only: [:new]
  before_filter :authenticate_user!
  respond_to :html
  respond_to :js, only: :create
  protected
  def begin_of_association_chain
    current_shop
  end
  def collection
    collection ||= end_of_association_chain.order('id desc').page(params[:page])
  end
end
