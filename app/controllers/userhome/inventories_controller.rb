class Userhome::InventoriesController < UserhomeController
  protected
  def begin_of_association_chain
    current_shop
  end
end
