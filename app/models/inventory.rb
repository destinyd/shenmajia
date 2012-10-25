class Inventory < ActiveRecord::Base
  acts_as_commentable

  attr_accessor :name
  attr_accessible :amount, :current, :good_id, :original, :price_id, :name#, :shop_id, :type_id
  belongs_to :shop
  belongs_to :good
  belongs_to :price

  validates :current, presence: true
  validates :amount, presence: true
  validates :good_id, presence: true

  default_scope includes(:good,:price)
  scope :recent,order('created_at desc')
  scope :list,includes(:good,:shop)

  def name
    @name ||= (good.try(:name) || '')
  end

  def to_s
    name
  end

  after_initialize do
  	self.type_id = 101 if self.type_id.blank?
  end

  before_validation do
    unless self.original.blank?
      self.type_id = 102
      self.shop.prices.recent.where(good_id: self.good_id,type_id: 101,price: self.original,user_id:self.shop.user_id).first_or_create({},on: :bill)
    end
    self.price = 
      self.shop.prices.recent.where(good_id: self.good_id,type_id: self.type_id,price: self.current,user_id:self.shop.user_id).first_or_create({},on: :bill)
  end

  before_destroy do
    self.price.finish
  end
end
