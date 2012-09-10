class Userhome::InventoriesController < UserhomeController
  def begin_of_association_chain
    current_user.shops.first
  end
end
