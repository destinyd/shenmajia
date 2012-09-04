class AddContactIdToBill < ActiveRecord::Migration
  def change
    add_column :bills, :contact_id, :integer
    add_index :bills, :contact_id
  end
end
