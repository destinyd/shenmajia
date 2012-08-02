class AddCityIdToPrice < ActiveRecord::Migration
  def change
    add_column :prices, :city_id, :integer
    add_index :prices, :city_id
  end
end
