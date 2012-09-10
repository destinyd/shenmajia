class Userhome::InventoriesController < UserhomeController
  actions :all, except: [:create,:update]
  protected
  def begin_of_association_chain
    current_user.shops.first
  end
end
