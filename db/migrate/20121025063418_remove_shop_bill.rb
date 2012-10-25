class RemoveShopBill < ActiveRecord::Migration
  def up
    Bill.where(locatable_type:'Shop').destroy_all
  end

  def down
  end
end
