class CreatePlaceGoods < ActiveRecord::Migration
  def change
    create_table :place_goods do |t|
      t.integer :place_id
      t.integer :good_id

      t.timestamps
    end
    add_index :place_goods, :place_id
    add_index :place_goods, :good_id
  end
end
