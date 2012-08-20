class AddFullyPaidToBill < ActiveRecord::Migration
  def change
    add_column :bills, :fully_paid, :boolean, :default => false
  end
end
