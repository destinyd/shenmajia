class UploadsController < InheritedResources::Base
  before_filter :authenticate_user!, only: [:new,:create,:edit,:update,:destroy]
  actions :all,except: [:edit,:update,:destroy]
  belongs_to :good, optional: true
  
  protected
  def collection
    @uploads ||= end_of_association_chain.paginate(page: params[:page])
  end
end
