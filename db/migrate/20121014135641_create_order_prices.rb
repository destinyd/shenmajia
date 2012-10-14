class CreateOrderPrices < ActiveRecord::Migration
  def change
    create_table :order_prices do |t|
      t.integer :order_id
      t.integer :price_id
      t.integer :amount

      t.timestamps
    end
    add_index :order_prices, :order_id
    add_index :order_prices, :price_id
  end
end
