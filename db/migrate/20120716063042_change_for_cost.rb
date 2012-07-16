class ChangeForCost < ActiveRecord::Migration
  def up
    rename_column :costs,:locate_id, :locatable_id
    add_column :costs, :locatable_type, :string,:limit => 20
    add_index :costs, :locatable_type
    remove_column :costs, :shop_id
  end

  def down
    add_column :costs, :shop_id, :integer
    add_index :costs, :shop_id
    execute "delete from costs where locatable_type != 'Locate'"
    remove_column :costs, :locatable_type
    rename_column :costs,:locatable_id, :locate_id
  end
end
