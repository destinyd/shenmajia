class BillPrice < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  attr_accessible :bill_id, :price_id, :amount,:image
  belongs_to :bill
  belongs_to :price
  belongs_to :upload
  after_create do
    unless image.blank?
      @image = read_attribute(:image)
      u = price.uploads.new
      u.image_file_name = @image
      u.save

      self.upload_id = u.id
      self.save

      price.image= @image if price.image.blank?
      price.save

      u = price.good.uploads.new
      u.image_file_name = @image
      u.save
      price.good.image= @image if price.good.image.blank?
      price.good.save
    end
  end
end
