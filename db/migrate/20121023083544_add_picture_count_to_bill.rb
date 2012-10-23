class AddPictureCountToBill < ActiveRecord::Migration
  def change
    add_column :goods, :picture_count, :integer,default: 0
    add_index :goods, :picture_count
    add_column :bills, :picture_count, :integer,default: 0
    add_index :bills, :picture_count
  end
end
