class AddImageToPrice < ActiveRecord::Migration
  def change
    add_column :prices, :image, :string
  end
end
