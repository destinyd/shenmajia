# coding: utf-8
class Cost < ActiveRecord::Base
  attr_accessor :name,:address,:unit,:unit_price#,:shop
  attr_accessible :name,:good_id,:price_id,:money,:shop_id,:costs_attributes,:locatable_type,:locatable_id,:locatable,:desc,:unit,:amount,:unit_price#:price_attributes#,:price
  validates :money, :presence => true
  validates :lat, :presence => true
  validates :lon, :presence => true
  belongs_to :user
  belongs_to :good
  belongs_to :cost
  belongs_to :price
  #belongs_to :locate
  #belongs_to :shop
  belongs_to :locatable, :polymorphic => true

  has_many :costs
  #accepts_nested_attributes_for :costs
  #accepts_nested_attributes_for :price

  #has_many :good_costs,:dependent => :destroy
  #has_many :goods , :through => :good_costs

  #has_many :user_costs,:dependent => :destroy
  #has_many :users,:through => :user_costs
  #has_many :price_costs,:dependent => :destroy
  #has_many :prices,:through => :price_costs


  scope :recent,order("id desc")

  acts_as_commentable

  def name
    good.try(:name)
  end

  def form_price
    unit_price ||= last_price
  end

  def last_price
    good.prices.last
  end

  def costs_in_same_good
    return @costs_in_same_good if @costs_in_same_good
    @costs_in_same_good = Cost.where(:good_id => self.good_id).where("id != ?",self.id).recent
  end

  def costs_in_same_locatable
    return @costs_in_same_locatable if @costs_in_same_locatable
    @costs_in_same_locatable = self.locatable.costs.where("id != ?",self.id).recent
  end

  def other_good_costs
    "在#{locatable}购买#{amount}#{good.unit}，共消费#{money}元"
  end

  def other_locatable_costs
    "购买#{good}*#{amount}#{good.unit}，共消费#{money}元"
  end

  before_create :create_good,:create_price

  protected
  def create_good
    self.good = Good.create :name => name, :unit => unit if good_id.blank? and ! unit.blank?
  end

  def create_price
    unless unit_price.blank?
      self.price = Price.where(:price => unit_price,:good_id => self.good_id).last
      self.price = user.prices.create(:price => unit_price,:latitude => locatable.lat, :longitude => locatable.lon,:good_id => good_id,:locatable => locatable,:type_id => 0) unless self.price
    end
  end
end
