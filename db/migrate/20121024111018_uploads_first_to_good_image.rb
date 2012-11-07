class UploadsFirstToGoodImage < ActiveRecord::Migration
  def up
    Good.where(picture_count:1..999).each do |good|
      good.write_uploader(:image, good.uploads.first.read_attribute(:image_file_name))
      good.save
    end
  end
  def down
  end
end
