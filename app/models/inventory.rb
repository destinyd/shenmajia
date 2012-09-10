class Inventory < ActiveRecord::Base
  attr_accessor :name
  attr_accessible :amount, :current, :good_id, :original, :price_id, :name#, :shop_id, :type_id
  belongs_to :shop
  belongs_to :good
  belongs_to :price

  validates :current, presence: true
  validates :amount, presence: true
  validates :good_id, presence: true

  default_scope includes(:good,:price)

  def name
  	good.try(:name)
  end

  after_initialize do
  	self.type_id = 101 if self.type_id.blank?
  end

  before_validation do
	p = self.shop.prices.recent.where(good_id: self.good_id,type_id: 101).first
	if p and p.price == current
		self.price = p
	else
		self.price =  self.shop.prices.new price: current, good_id: self.good_id, type_id: 101
		self.price.user_id = self.shop.user_id
		self.price.save
	end
  	unless original.blank?
  		self.type_id = 102
  		p = self.shop.prices.recent.where(good_id: self.good_id,type_id: 102).first
  		unless p and p.price == original
  			p = self.shop.prices.new price: original, good_id: self.good_id, type_id: 102
  			p.user_id = self.shop.user_id
  			p.save
		end
  	end
  end

  before_destroy do
    self.price.finish
  end
end
