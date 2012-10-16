class Shop::ShopContactsController < ShopController
  def create
    create!{shop_shop_contacts_path}
  end

  def destroy
    destroy!{shop_shop_contacts_path}
  end
end

