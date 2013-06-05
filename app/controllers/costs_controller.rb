class CostsController < InheritedResources::Base
  before_filter :authenticate_user!,only: [:new,:create]
  actions :all, except: [:edit,:update,:destroy]
  #belongs_to :city,finder: :find_by_name!, optional: true
  #belongs_to :place, optional: true
  #belongs_to :good, optional: true
  #belongs_to :place, optional: true
  belongs_to :bill, optional: true
  respond_to :html

  respond_to :js, only: [:index, :new]

  #caches_page :index,:show
  #cache_sweeper :cost_sweeper

  def create
    @cost = resource = current_user.costs.new params[:cost]
    create! do |format|
      format.html
    end
  end

  protected
  def collection
    @costs ||= end_of_association_chain.recent.page(params[:page])
  end
end
