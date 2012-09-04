class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.integer :good_id
      t.integer :price_id
      t.integer :shop_id
      t.integer :type_id
      t.decimal :current, :precision => 16, :scale => 2
      t.decimal :amount, :precision => 10, :scale => 3
      t.decimal :original, :precision => 16, :scale => 2

      t.timestamps
    end
    add_index :inventories, :good_id
    add_index :inventories, :price_id
    add_index :inventories, :type_id
    add_index :inventories, :shop_id
  end
end
