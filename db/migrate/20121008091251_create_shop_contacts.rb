class CreateShopContacts < ActiveRecord::Migration
  def change
    create_table :shop_contacts do |t|
      t.integer :shop_id
      t.string :qq
      t.string :phone

      t.timestamps
    end
    add_index :shop_contacts, :shop_id
  end
end
