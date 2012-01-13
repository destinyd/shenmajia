# coding: utf-8
class Good < ActiveRecord::Base
  STATUS_LOW = 2
  belongs_to :user
  has_many :price_goods
  has_many :prices,:through => :price_goods
  has_many :outlinks, :as => :outlinkable
  has_many :records, :as => :recordable
  has_many :uploads, :as => :uploadable
  has_many :focuss, :as => :focusable
  has_many :attrs, :as => :attrable
  has_many :reviews, :as => :reviewable

  accepts_nested_attributes_for :outlinks

  scope :review_type, Filter.new(self).extend(ReviewTypeFilter)

  validates :name, :presence => true,:uniqueness => true
  
  acts_as_commentable
  acts_as_taggable

#  default_scope order('id desc')#.includes(:prices) #

  scope :recent,order('id desc').includes(:reviews).limit(10)

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end

  def cheapest
    @cheapest = self.prices.min{|price| price.price}
    checapest_price = @cheapest.try(:human_price)
    checapest_price ||= "none"
  end

  def to_s
    return self.name + '(待审)' if self.is_valid.nil?# and self.reviews.sum(:status) < STATUS_LOW
    self.name
  end

  has_many :integrals, :as => :integralable
  def valid
    return if self.is_valid
    self.update_attribute(:is_valid, true)
    self.user.get_point(5,self)
  end
  
end
