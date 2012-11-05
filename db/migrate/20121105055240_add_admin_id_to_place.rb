class AddAdminIdToPlace < ActiveRecord::Migration
  def change
    add_column :places, :admin_id, :integer
    add_index :places, :admin_id
  end
end
