# coding: utf-8
class Cost
  include Mongoid::Document
  include Mongoid::Timestamps
  field :amount,              :type => Float
  field :money,              :type => Float
  field :deleted_at,              :type => Date
  field :desc,              :type => String
  #acts_as_paranoid
  #acts_as_commentable
  has_many :comments, as: :commentable
  attr_accessor :name, :address, :unit, :unit_price, :norm
  attr_accessible :name, :good_id, :price_id, :money, :costs_attributes, :desc, :unit, :amount, :unit_price, :norm, :bill_id#:price_attributes#, :price
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


  scope :recent,desc(:created_at)
  #scope :with_price,includes(:price)
  #scope :with_good,includes(:good)

  #scope :with_bill,includes(:bill)

  default_scope includes([:user,:bill])

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

  def to_s
    "#{user}消费#{money}元"
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
end
