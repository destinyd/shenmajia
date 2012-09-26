class CreateUserVips < ActiveRecord::Migration
  def change
    create_table :user_vips do |t|
      t.datetime :started_at
      t.datetime :finish_at
      t.integer :user_id

      t.timestamps
    end
    add_index :user_vips, :user_id
  end
end
