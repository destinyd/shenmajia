class GoodImageToPrice < ActiveRecord::Migration
  def up
    Good.where('goods.image is not null').each do |good|
      good.prices.where('prices.image is null').update_all image:good.read_attribute(:image)
    end
  end

  def down
  end
end
