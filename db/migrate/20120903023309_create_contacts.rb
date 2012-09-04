class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :city_id
      t.integer :area_id
      t.string :address
      t.string :telephone
      t.string :phone
      t.string :name
      t.integer :user_id
      t.boolean :is_default, :default => 0

      t.timestamps
    end
    add_index :contacts, :city_id
    add_index :contacts, :area_id
    add_index :contacts, :user_id
    add_index :contacts, :is_default
  end
end
