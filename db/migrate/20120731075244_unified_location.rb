class UnifiedLocation < ActiveRecord::Migration
  def up
    rename_column :prices, :latitude, :lat
    rename_column :prices, :longitude, :lon
    rename_column :places, :addr, :address
  end

  def down
    rename_column :places, :address, :addr
    rename_column :prices, :lon, :longitude
    rename_column :prices, :lat, :latitude
  end
end
