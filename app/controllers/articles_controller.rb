class ArticlesController < InheritedResources::Base
  before_filter :authenticate_admin!, only: [:new,:create,:edit,:update,:destroy]

  protected
  def collection
    @articles ||= end_of_association_chain.recent.page(params[:page])
  end
end
