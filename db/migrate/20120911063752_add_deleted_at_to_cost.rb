class AddDeletedAtToCost < ActiveRecord::Migration
  def change
    add_column :costs, :deleted_at, :datetime
  end
end
