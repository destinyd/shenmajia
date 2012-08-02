class GivePriceCityId < ActiveRecord::Migration
  def up
    City.all.each{|c| ActiveRecord::Base.connection.execute "update prices set city_id = #{c.id} where id in (#{Price.near([c.lat,c.lon],20).where(:city_id => nil).map(&:id).join(',')})" unless Price.near([c.lat,c.lon],20).where(:city_id => nil).blank?}
  end

  def down
  end
end
