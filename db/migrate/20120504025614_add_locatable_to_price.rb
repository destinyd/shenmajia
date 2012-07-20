class AddLocatableToPrice < ActiveRecord::Migration
  def change
    add_column :prices, :locatable_id, :integer
    add_column :prices, :locatable_type, :string , :limit => 20
    add_index :prices, [:locatable_id,:locatable_type]
  end
end
