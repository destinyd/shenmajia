class AddSomethingsToGood < ActiveRecord::Migration
  def change
    add_column :goods, :norm, :string, :limit => 50
    add_column :goods, :unit, :string, :limit => 50
    add_column :goods, :barcode, :string, :limit => 50
    add_column :goods, :origin, :string, :limit => 50
  end
end
