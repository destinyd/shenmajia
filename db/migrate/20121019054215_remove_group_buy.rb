class RemoveGroupBuy < ActiveRecord::Migration
  def up
    #@prices = Price.where(type_id:21..22).select('id,good_id')#.map(&:good_id)
    #tmp = @prices.map(&:good_id)#.join(',')
    tmp = 'select good_id from prices where type_id between 21 and 22'
    execute "delete from uploads where uploadable_type='Good' and uploadable_id in (#{tmp})"
    execute "delete from outlinks where outlinkable_type='Good' and outlinkable_id in (#{tmp})"
    execute "delete from goods where id in (#{tmp})"
    execute "delete from prices where type_id between 21 and 22"
    execute "delete prices from prices left join goods on prices.good_id = goods.id where goods.id is null;"
    #Price.delete_all id: @prices.map(&:id)
    #groupbuy_good_ids.group_by{|ids| ids/500}.each do |k,v|
      #Good.transaction do
        #Good.destroy_all id:v
      #end
    #end
  end

  def down
  end
end
