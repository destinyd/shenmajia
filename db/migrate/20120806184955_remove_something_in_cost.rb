class RemoveSomethingInCost < ActiveRecord::Migration
  def up
    remove_column :costs, :good_id
    remove_column :costs, :price_id
    remove_column :costs, :cost_id
    remove_column :costs, :locate_id
    remove_column :costs, :locatable_id
    remove_column :costs, :locatable_type
  end

  def down
    add_column :costs, :good_id, :integer
    add_column :costs, :price_id, :integer
    add_column :costs, :cost_id, :integer
    add_column :costs, :locate_id, :integer
    add_column :costs, :locatable_id, :integer
    add_column :costs, :locatable_type, :string, :limit => 20

    add_index :costs, :good_id
    add_index :costs, :price_id
    add_index :costs, :cost_id
    add_index :costs, :locate_id
    add_index :costs, [:locatable_id, :locatable_type]
  end
end
