class AddBillIdToCost < ActiveRecord::Migration
  def change
    add_column :costs, :bill_id, :integer
    add_index :costs, :bill_id
  end
end
