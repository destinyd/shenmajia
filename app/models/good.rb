# coding: utf-8
class Good < ActiveRecord::Base
  attr_accessor :brand_name,:product_name,:norm_name#,:brand_name,
  STATUS_LOW = 2
  belongs_to :user
  belongs_to :brand
  belongs_to :product
  has_many :brand_goods,dependent:  :destroy
  has_many :brands,through:  :brand_goods

  has_many :prices
  has_many :bills,through:  :prices#,foreign_key:  :package_id
  has_many :outlinks, as:  :outlinkable
  has_many :records, as:  :recordable
  has_many :uploads, as:  :uploadable, dependent: :destroy
  has_many :focuss, as:  :focusable
  has_many :attrs, as:  :attrable
  has_many :reviews, as:  :reviewable
  has_many :integrals, as:  :integralable
  has_many :package_goods, dependent:  :destroy
  has_many :good_packages,foreign_key:  :package_id,class_name:  'PackageGood', dependent:  :destroy
  has_many :goods,through:  :package_goods,source: :package#,foreign_key:  :package_id
  has_many :packages,through:  :good_packages,source: :good,foreign_key:  :package_id

  has_many :shop_goods,dependent:  :destroy
  has_many :shops,through:  :shop_goods

  has_many :place_goods,dependent:  :destroy
  has_many :places,through:  :place_goods

  has_many :inventories

  #has_many :good_costs,dependent:  :destroy
  #has_many :costs , through:  :good_costs
  #has_many :costs

  accepts_nested_attributes_for :outlinks
  accepts_nested_attributes_for :uploads

  scope :review_type, Filter.new(self).extend(ReviewTypeFilter)
  scope :recent,order('id desc')#.includes(:reviews).limit(10)
  scope :running,where(deleted_at:  DateTime.new(0))
  scope :list,select('goods.id,goods.name,goods.norm,goods.unit,goods.origin,goods.created_at')
  scope :with_pic,where('goods.picture_count > 0')

  validates :name, presence:  true,uniqueness:  {scope:  [:unit,:norm]}
  validates :unit, presence:  true
  
  acts_as_commentable
  acts_as_taggable

  default_scope includes(:uploads) #

  after_initialize do
    self.unit = '份' if self.unit.blank?
    self.deleted_at = DateTime.new(0) if self.deleted_at.nil?
    self.picture_count = 0 if self.picture_count.nil?
  end

  def self.search(q)
    unless q.blank?
      running.where('name LIKE ?', "%#{q}%")
    else
      running 
    end
  end

  # def build_name
  #   brand.try(:name) + product.try(:name) + norm.try(:name)
  # end

  def cheapest
    @cheapest = self.prices.min{|price| price.price}
    cheapest_price = @cheapest.try(:human_price)
    cheapest_price ||= "none"
  end

  def to_s
    #return self.name + '(待审)' if self.is_valid.nil?# and self.reviews.sum(:status) < STATUS_LOW
    self.name
  end

  def valid
    return false if self.is_valid
    self.update_attribute(:is_valid, true)
  end

  def valid_with_exp
    self.user.get_point(1,self,1) if self.user_id and valid
  end

  def valid_if_user_is_vip
    valid if self.user.try(:is_vip?)
  end

  before_create :uniq_barcode_or_nil
  after_create :exp,:valid_if_user_is_vip

  def uniq_barcode_or_nil
    barcode = nil if barcode == ''
    raise 'uniq_barcode_or_nil' if !barcode.blank? and !Good.where(barcode: barcode).blank?
  end

  def exp
    self.user.get_point(1,self) if self.user_id
  end

  def shop_price shop
    if @shop_price.nil?
      @shop_price = prices.shop_price(shop).first.try(:price) || false
    end
    @shop_price
  end
end
