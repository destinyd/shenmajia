class DeleteGroupbuyGoods < ActiveRecord::Migration
  def up
    execute 'UPDATE goods SET deleted_at = NOW() WHERE id IN (SELECT good_id FROM prices WHERE type_id IN (21,22))'
  end

  def down
    execute 'UPDATE goods SET deleted_at = "0000-01-01 00:00:00" WHERE id IN (SELECT good_id FROM prices WHERE type_id IN (21,22))'
  end
end
