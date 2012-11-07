class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      #t.string :name
      t.string :image
      #t.string :category
      #t.integer :user_id
      #t.integer :page
      t.datetime :exired_at
      t.integer :place_id

      t.timestamps
    end
    #add_index :menus, :page
    #add_index :menus, :user_id
    add_index :menus, :place_id
  end
end
