class OutlinksController < InheritedResources::Base
  before_filter :authenticate_user!#, only: [:index,:new,:create,:edit,:update,:destroy]
  belongs_to :flash, optional: true
  belongs_to :price, optional: true

  protected
  def collection
    @outlinks ||= end_of_association_chain.recent.paginate(page: params[:page])
  end
end
