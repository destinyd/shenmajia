class AddImageToGood < ActiveRecord::Migration
  def change
    add_column :goods, :image, :string
    Good.where(picture_count:1..999).each do |u|
      u.image = u.uploads.first.read_attribute(:image_file_name)
      u.save
    end
  end
end
