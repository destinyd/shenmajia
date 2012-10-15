class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :shop_id
      t.integer :user_id
      t.integer :status
      t.decimal :total, :precision => 8, :scale => 2

      t.timestamps
    end
    add_index :orders, :shop_id
    add_index :orders, :user_id
    add_index :orders, :status
  end
end
