class AddDeletedAtToPrice < ActiveRecord::Migration
  def change
    add_column :prices, :deleted_at, :datetime
  end
end
