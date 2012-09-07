class MsgsController < InheritedResources::Base
  before_filter :authenticate_user!#, only: [:index,:new,:create,:edit,:update,:destroy]

  protected
  def begin_of_association_chain
    current_user
  end

  def collection
    @msgs ||= end_of_association_chain.paginate(page: params[:page])
  end
end
