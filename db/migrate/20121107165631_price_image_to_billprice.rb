class PriceImageToBillprice < ActiveRecord::Migration
  def up
    BillPrice.where(image:nil).includes(:price).each do |bill_price|
      if bill_price.price and !bill_price.price.image.blank?
        bill_price.write_uploader(:image, bill_price.price.read_attribute(:image))
        bill_price.save
      end
    end

  end

  def down
  end
end
