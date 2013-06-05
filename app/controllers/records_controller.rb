class RecordsController < InheritedResources::Base
  before_filter :authenticate_admin!#, only: [:index,:new,:create,:edit,:update,:destroy]

  protected
  def collection
    @records ||= end_of_association_chain.recent.page(params[:page])
  end
end
