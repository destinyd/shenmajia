class AddIndexToGood < ActiveRecord::Migration
  def change
    add_index :goods, [:name,:unit,:norm]
  end
end
