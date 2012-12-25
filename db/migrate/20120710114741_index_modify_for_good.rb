class IndexModifyForGood < ActiveRecord::Migration
  def up
    remove_index :goods, :name
    add_index :goods,:name
    add_index :goods, :barcode, :uniq => true
  end
  
  def down
    remove_index :goods, :barcode
    remove_index :goods, :name
    add_index :goods,:name,:unique => true
  end
end
