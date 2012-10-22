class FlashesController < InheritedResources::Base
  before_filter :authenticate_user!,:admin?#, only: [:index,:new,:create,:edit,:update,:destroy]

  protected
  def collection
    @flashes ||= end_of_association_chain.recent.paginate(page: params[:page])
  end

  def admin?
    current_user.id == 1 ? true : not_found
  end
end
