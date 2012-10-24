class AddImageToBillPrice < ActiveRecord::Migration
  def change
    add_column :bill_prices, :image, :string
    add_column :bill_prices, :upload_id, :integer
    add_index :bill_prices, :upload_id#, :integer
  end
end
