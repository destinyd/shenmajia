class NormsController < InheritedResources::Base
  before_filter :authenticate_user!,only: [:new,:create,:update,:edit,:destroy]
  actions :all,except: [:edit,:update,:destroy]
  belongs_to :brand, optional: true
  respond_to :html

  def create
     @norm = current_user.norms.new(params[:norm])
     create!
  end
  protected
  def collection
    @norms ||= end_of_association_chain.paginate(page: params[:page])
  end
end
