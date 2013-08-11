# coding: utf-8
class Good
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name,              :type => String
  field :desc,              :type => String
  field :norm,              :type => String
  field :unit,              :type => String, default: '份'
  field :barcode,              :type => String
  field :origin,              :type => String
  field :image,              :type => String

  field :is_valid,              :type => Boolean
  field :deleted_at,              :type => Date
  field :picture_count,              :type => Integer, default: 0

  mount_uploader :image, ImageUploader
  attr_accessible :product_name,:brand_name,:norm_name,:name,:desc,:norm,:unit,:barcode,:origin,:tag_list, :xhr
  attr_accessor :brand_name,:product_name,:norm_name, :xhr#,:brand_name,
  STATUS_LOW = 2
  belongs_to :user
  belongs_to :brand
  belongs_to :product

  has_many :prices
  #has_many :bills,through:  :prices#,foreign_key:  :package_id
  has_many :outlinks, as:  :outlinkable
  has_many :uploads, as:  :uploadable, dependent: :destroy
  has_many :focuss, as:  :focusable
  has_many :attrs, as:  :attrable
  #has_many :reviews, as:  :reviewable
  has_many :integrals, as:  :integralable
  #has_many :package_goods, dependent:  :destroy
  #has_many :good_packages,foreign_key:  :package_id,class_name:  'PackageGood', dependent:  :destroy
  #has_many :goods,through:  :package_goods,source: :package#,foreign_key:  :package_id
  #has_many :packages,through:  :good_packages,source: :good,foreign_key:  :package_id

  #has_many :good_costs,dependent:  :destroy
  #has_many :costs , through:  :good_costs
  #has_many :costs
  has_many :comments, as: :commentable
  has_many :infos

  accepts_nested_attributes_for :outlinks
  accepts_nested_attributes_for :uploads

  #scope :review_type, Filter.new(self).extend(ReviewTypeFilter)
  scope :recent,desc(:updated_at)#.includes(:reviews).limit(10)
  scope :running,where(deleted_at:  DateTime.new(0))
  #scope :list,select('goods.id,goods.name,goods.norm,goods.unit,goods.origin,goods.created_at,goods.image')
  scope :with_pic,where(:image.exists => true)
  scope :with_barcode,where(:barcode.nin => ["",nil], :barcode.exists => true)

  validates :name, presence:  true,uniqueness:  {scope:  [:unit,:norm]}
  validates :unit, presence:  true
  
  #acts_as_commentable
  #acts_as_taggable

  #default_scope includes(:uploads) #

  after_initialize do
    self.deleted_at = DateTime.new(0) if self.deleted_at? and self.deleted_at.nil?
    self.picture_count = 0 if self.picture_count? and self.picture_count.nil?
  end

  def self.search(q)
    q = '你应该不知道搜索什么把' if q.blank?
    any_of({barcode: q},{name: Regexp.new(q)})
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
  #after_create :exp,:valid_if_user_is_vip

  def uniq_barcode_or_nil
    barcode = nil if barcode == ''
    raise 'uniq_barcode_or_nil' if !barcode.blank? and !Good.where(barcode: barcode).blank?
  end

  def exp
    self.user.get_point(1,self) if self.user_id
  end
end
