class AddPlaceIdToShop < ActiveRecord::Migration
  def change
    add_column :shops, :place_id, :integer
    add_index :shops, :place_id
  end
end
