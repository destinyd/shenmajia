class BillsController < InheritedResources::Base
  before_filter :authenticate_user!,:only => [:new,:create]
  actions :all, :except => [:edit,:update,:destroy]
  belongs_to :place, :optional => true
  respond_to :html

  respond_to :js, :only => :index

  def collection
    @costs = collection ||= end_of_association_chain.recent.paginate(:page => params[:page])
  end
end
