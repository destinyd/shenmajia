class RemoveSomeFromShop < ActiveRecord::Migration
  def up
  	remove_column :shops, [:address,:lat,:lon]
  end

  def down
  	add_column :shops, :lon, :double
  	add_column :shops, :lat, :double
  	add_column :shops, :address, :string
  	add_index :shops, :lat
  	add_index :shops, :lon
  end
end
