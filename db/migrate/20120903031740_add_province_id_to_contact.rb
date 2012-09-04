class AddProvinceIdToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :province_id, :integer
    add_index :contacts, :province_id
  end
end
