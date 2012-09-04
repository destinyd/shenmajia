class AddCityIdToShop < ActiveRecord::Migration
  def change
    add_column :shops, :city_id, :integer
    add_index :shops, :city_id
  end
end
