# coding: utf-8
class Cost < ActiveRecord::Base
  attr_accessor :name, :address, :unit, :unit_price, :norm#, :shop
  attr_accessible :name, :good_id, :price_id, :money, :shop_id, :costs_attributes, :locatable_type, :locatable_id, :locatable, :desc, :unit, :amount, :unit_price, :norm, :bill_id#:price_attributes#, :price
  attr_accessible :user_id, on: :bill
  validates :money, presence: true
  belongs_to :user
  #belongs_to :good
  #belongs_to :cost
  #belongs_to :price

  belongs_to :bill

  #has_many :costs
  #accepts_nested_attributes_for :costs
  #accepts_nested_attributes_for :price

  #has_many :good_costs,dependent: :destroy
  #has_many :goods , through: :good_costs

  #has_many :user_costs,dependent: :destroy
  #has_many :users,through: :user_costs
  #has_many :price_costs,dependent: :destroy
  #has_many :prices,through: :price_costs


  scope :recent,order("costs.id desc")
  #scope :with_price,includes(:price)
  #scope :with_good,includes(:good)

  #scope :with_locatable,includes(:locatable)
  scope :with_bill,includes(:bill)
  acts_as_commentable

  def form_price
    unit_price ||= price.try(:price) 
    unit_price ||= last_price.try(:price)
  end

  def last_price
    good_id.blank? ? nil : good.prices.last
  end

  def costs_in_same_good
    return @costs_in_same_good if @costs_in_same_good
    @costs_in_same_good = Cost.where(good_id: self.good_id).where("id != ?",self.id).recent
  end

  def costs_in_same_locatable
    return @costs_in_same_locatable if @costs_in_same_locatable
    @costs_in_same_locatable = self.locatable.costs.where("id != ?",self.id).recent
  end

  #def other_good_costs
    #"在#{locatable}购买#{amount}#{good.unit}，共消费#{money}元"
  #end

  #def other_locatable_costs
    #"购买#{good}*#{amount}#{good.unit}，共消费#{money}元"
  #end

  def locatable
    bill.locatable if bill
  end

  def to_s
    if self.locatable
      "#{user}于#{locatable}消费#{money}元"      
    else
      "#{user}消费#{money}元"
    end
  end

  # include UnitInitHelper
  # before_create :create_good,:create_price

  # protected
  # def create_good
  #   if good.blank?
  #     self.good = Good.where(name: name, unit: unit, norm: norm).first
  #     self.good = self.user.goods.create name: name, unit: unit, norm: norm unless self.good
  #   end
  # end

  # def create_price
  #   unless unit_price.blank?
  #     self.price = Price.where(price: unit_price,good_id: self.good_id).last
  #     self.price = user.prices.create(price: unit_price,lat: locatable.lat, lon: locatable.lon,good_id: good_id,locatable: locatable,type_id: 0, city_id: locatable.city_id) unless self.price
  #   end
  # end
end
