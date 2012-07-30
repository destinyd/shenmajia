class AddJiepangToPlace < ActiveRecord::Migration
  def change
    #add_column :places, :place_jiepang_id, :integer
    #add_index :places, :place_jiepang_id, :uniq => true
    add_column :places, :city_id, :integer
    add_index :places, :city_id
    add_column :places, :jiepang, :text
  end
end
