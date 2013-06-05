class Shop
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name
  field :desc
  field :is_valid,              :type => Boolean
  attr_accessible :desc, :name,:brand_id,:tag_list
  validates :name, presence:  true
  # validates :address, presence:  true

  belongs_to :user
  belongs_to :brand
  belongs_to :city
  has_many :shop_goods,dependent:  :destroy
  #has_many :goods,through:  :shop_goods
  has_many :prices
  has_many :costs
  has_many :inventories
  has_many :bills
  has_many :orders
  has_many :shop_contacts

  # geocoded_by :address, latitude :  :lat, longitude:  :lon
  # after_validation :geocode, if:  [:no_locate?,:address_changed?]#,on: :create

  #acts_as_taggable

  # def no_locate?
  #   self.lat.nil? or self.lon.nil?
  # end

  def valid
    self.update_attribute :is_valid, true unless self.is_valid
  end
  
  def to_s
    name
  end
end
