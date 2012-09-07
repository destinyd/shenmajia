class AddIndexToArticleAndRecord < ActiveRecord::Migration
  def change
    add_index :articles, :user_id
    add_index :records, :user_id
  end
end
