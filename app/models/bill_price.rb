class BillPrice < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  attr_accessible :bill_id, :price_id, :amount,:image
  belongs_to :bill
  belongs_to :price
  belongs_to :upload

  scope :with_pic,where('bill_prices.image is not null')

  after_create do
    unless image.blank?
      @image = read_attribute(:image)
      #u = price.uploads.new
      #u.image_file_name = @image
      #u.save

      if price.image.blank?
        price.write_uploader(:image, @image) 
        price.save
      end

      u = price.good.uploads.new
      u.image_file_name = @image
      u.save
      if price.good.image.blank?
        price.good.write_uploader(:image, @image)
        price.good.save if price.good.changed?
      end

      self.upload_id = u.id
      self.save
    end
  end
end
