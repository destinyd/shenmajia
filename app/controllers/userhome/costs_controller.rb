class Userhome::CostsController < UserhomeController
  actions :all, only: [:index]
  protected
  def collection
    @costs = collection ||= end_of_association_chain#.paginate(page: params[:page])
  end
end
