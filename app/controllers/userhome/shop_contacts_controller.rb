class Userhome::ShopContactsController < UserhomeController
  layout 'userhome'
  def create
    create!{userhome_shop_contacts_path}
  end

  def destroy
    destroy!{userhome_shop_contacts_path}
  end
  protected
  def begin_of_association_chain
    current_shop
  end

end

