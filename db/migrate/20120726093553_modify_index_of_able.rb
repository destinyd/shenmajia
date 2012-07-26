class ModifyIndexOfAble < ActiveRecord::Migration
  def up
    remove_index :attrs, :attrable_id
    remove_index :attrs, :attrable_type
    add_index :attrs, [:attrable_id,:attrable_type]

    remove_index :comments, :commentable_id
    remove_index :comments, :commentable_type
    add_index :comments, [:commentable_id,:commentable_type]

    remove_index :focus, :focusable_id
    remove_index :focus, :focusable_type
    add_index :focus, [:focusable_id,:focusable_type]

    remove_index :integrals, :integralable_id
    remove_index :integrals, :integralable_type
    add_index :integrals, [:integralable_id,:integralable_type]

    remove_index :outlinks, :outlinkable_id
    remove_index :outlinks, :outlinkable_type
    add_index :outlinks, [:outlinkable_id,:outlinkable_type]

    remove_index :reviews, :reviewable_id
    remove_index :reviews, :reviewable_type
    add_index :reviews, [:reviewable_id,:reviewable_type]

    add_index :records, [:recordable_id,:recordable_type]

    remove_index :uploads, :uploadable_id
    remove_index :uploads, :uploadable_type
    add_index :uploads, [:uploadable_id,:uploadable_type]

  end

  def down
    remove_index :uploads, [:uploadable_id,:uploadable_type]
    add_index :uploads, :uploadable_id
    add_index :uploads, :uploadable_type

    remove_index :records, [:recordable_id,:recordable_type]

    remove_index :reviews, [:reviewable_id,:reviewable_type]
    add_index :reviews, :reviewable_id
    add_index :reviews, :reviewable_type

    remove_index :outlinks, [:outlinkable_id,:outlinkable_type]
    add_index :outlinks, :outlinkable_id
    add_index :outlinks, :outlinkable_type

    remove_index :integrals, [:integralable_id,:integralable_type]
    add_index :integrals, :integralable_id
    add_index :integrals, :integralable_type

    remove_index :focus, [:focusable_id,:focusable_type]
    add_index :focus, :focusable_id
    add_index :focus, :focusable_type

    remove_index :comments, [:commentable_id,:commentable_type]
    add_index :comments, :commentable_id
    add_index :comments, :commentable_type

    remove_index :attrs, [:attrable_id,:attrable_type]
    add_index :attrs, :attrable_id
    add_index :attrs, :attrable_type
  end
end
