class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :shop_id
      t.integer :user_id
      t.integer :status
      t.decimal :total

      t.timestamps
    end
    add_index :orders, :shop_id
    add_index :orders, :user_id
    add_index :orders, :status
  end
end
