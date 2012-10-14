class AddContactIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :contact_id, :integer
    add_index :orders, :contact_id
  end
end
