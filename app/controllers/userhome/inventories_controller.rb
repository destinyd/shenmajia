class Userhome::InventoriesController < UserhomeController
  actions :all, except: [:create,:update]
  protected
  def begin_of_association_chain
    current_shop
  end
end
