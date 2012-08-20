class AddDeletedAtToGood < ActiveRecord::Migration
  def change
    add_column :goods, :deleted_at, :datetime, :null => false,:default => '0000-01-01 00:00:00'
    add_index :goods, :deleted_at
  end
end
