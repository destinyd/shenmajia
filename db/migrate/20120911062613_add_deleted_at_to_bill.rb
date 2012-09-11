class AddDeletedAtToBill < ActiveRecord::Migration
  def change
    add_column :bills, :deleted_at, :datetime
  end
end
