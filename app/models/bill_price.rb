class BillPrice
  include Mongoid::Document
  include Mongoid::Timestamps
  field :amount,              :type => Float, default: 1
  field :image,              :type => String
  field :address,              :type => String
  #field :coordinates, :type => Array

  #include Geocoder::Model::Mongoid
  #geocoded_by :address
  mount_uploader :image, ImageUploader
  attr_accessor :name, :price_value, :good_id, :good
  attr_accessible :bill_id, :price_id, :amount,:image, :name, :price_value, :good_id
  belongs_to :bill
  belongs_to :price
  belongs_to :upload

  validates :amount, presence: true

  scope :with_pic,where('bill_prices.image is not null')

  before_validation :find_or_create_good, :find_or_create_price, on: :create

  def find_or_create_good
    if good_id.blank?
      self.good = Good.where(name: name).first
      self.good = bill.user.goods.create name: name if good.blank?
      self.good_id = self.good.id
    else
      self.good = Good.find(good_id)
    end
  end

  def find_or_create_price
    if self.price.blank? and !price_value.blank?
      self.price = Price.where(price: price_value, good: self.good).recent.first
      self.price = bill.user.prices.create good: self.good, price: price_value, lat: bill.lat, lon: bill.lon, image: image, address: self.bill.address unless self.price
    end
  end

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
