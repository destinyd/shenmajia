class CreatePlaceSearches < ActiveRecord::Migration
  def change
    create_table :place_searches do |t|
      t.string :q
      t.string :city
      t.column :lat, :double
      t.column :lon, :double

      t.timestamps
    end
    add_index :place_searches, :q
    add_index :place_searches, [:q,:city]
    add_index :place_searches, [:q,:lat,:lon]
  end
end
