class CreatePlaces < ActiveRecord::Migration
  def change
    create_table(:places) do |t|
      t.column :guid, "char(36)", :null => false
      t.string :name
      t.string :addr
      t.string :tel
      t.string :link
      t.column :lat,:double
      t.column :lon,:double

      t.timestamps
    end
    #execute "ALTER TABLE places ADD PRIMARY KEY (guid);"
    add_index :places, :name
    add_index :places, :guid, :unique => true
    add_index :places, [:lat,:lon]
  end
end
