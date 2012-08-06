class CreateBillPrices < ActiveRecord::Migration
  def change
    create_table :bill_prices do |t|
      t.integer :bill_id
      t.integer :price_id
      t.decimal :amount, :precision => 10,:scale => 3

      t.timestamps
    end
    add_index :bill_prices, :bill_id
    add_index :bill_prices, :price_id
  end
end
