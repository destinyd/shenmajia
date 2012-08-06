class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.decimal :total, :precision => 16,:scale => 2
      t.string :locatable_type, :limit => 20
      t.integer :locatable_id
      t.integer :user_id
      t.integer :shop_id
      t.datetime :ordered_at

      t.timestamps
    end
    add_index :bills, :user_id
    add_index :bills, :shop_id
    add_index :bills, :ordered_at
    add_index :bills, [:locatable_id, :locatable_type]
  end
end
