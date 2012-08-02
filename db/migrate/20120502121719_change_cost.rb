class ChangeCost < ActiveRecord::Migration
  def change
    rename_column :costs, :cost, :money
    add_column :costs, :cost_id, :integer
    add_index :costs, :cost_id
    #remove_index :costs,:locatable_id
    add_column :costs, :locatable_id, :integer
    add_column :costs, :locatable_type, :string, :limit => 20
    add_index :costs, [:locatable_id,:locatable_type]
    add_column :costs, :desc, :text
  end
end
