class Userhome::CostsController < UserhomeController
  protected
  def collection
    collection ||= end_of_association_chain#.paginate(page: params[:page])
  end
end
