class ChangeTypeIds < ActiveRecord::Migration
  def up
    #Price.where(:type_id => 1).each{|price| price.update_attribute :type_id,6}
    #Price.where(:type_id => 11).each{|price| price.update_attribute :type_id,1}
    execute "update prices set type_id=7 where type_id = 1"
    execute "update prices set type_id=1 where type_id = 11"
  end

  def down
    execute "update prices set type_id=11 where type_id = 1"
    execute "update prices set type_id=1 where type_id = 6"
    #Price.where(:type_id => 1).each{|price| price.update_attribute :type_id,11}
    #Price.where(:type_id => 6).each{|price| price.update_attribute :type_id,1}
  end
end
