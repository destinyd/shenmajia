class FlashesController < InheritedResources::Base
  before_filter :authenticate_user!,:admin?#, only: [:index,:new,:create,:edit,:update,:destroy]

  protected
  def collection
    @flashes ||= end_of_association_chain.recent.page(params[:page])
  end
end
