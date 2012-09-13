class Userhome::CostsController < UserhomeController
  actions :all, only: [:index]
  protected
  def collection
    collection ||= end_of_association_chain#.paginate(page: params[:page])
  end
end
