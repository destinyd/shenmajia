class TasksController < InheritedResources::Base
  before_filter :authenticate_admin!#, only: [:index,:new,:create,:edit,:update,:destroy]

  protected
  def collection
    @tasks ||= end_of_association_chain.paginate(page: params[:page])
  end
end
