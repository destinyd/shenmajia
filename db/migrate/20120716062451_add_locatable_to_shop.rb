class AddLocatableToShop < ActiveRecord::Migration
  def change
    add_column :shops, :locatable_id, :integer
    add_column :shops, :locatable_type, :string, :limit => 20
    add_index :shops, [:locatable_id,:locatable_type]
  end
end
