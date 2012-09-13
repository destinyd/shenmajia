# coding: utf-8
class Bill < ActiveRecord::Base
  acts_as_paranoid
  attr_accessor :cost, :desc
  attr_accessible :locatable_id, :locatable_type, :ordered_at, :total, :bill_prices_attributes, :cost, :desc, :contact_id
  has_many :bill_prices#, dependent: :destroy
  has_many :prices,through: :bill_prices
  has_many :goods,through: :prices
  has_many :costs, dependent: :destroy
  has_many :uploads, as: :uploadable
  belongs_to :locatable, polymorphic: true
  belongs_to :user
  belongs_to :shop
  belongs_to :contact

  accepts_nested_attributes_for :bill_prices, allow_destroy: true

  scope :recent,order("bills.id desc")

  after_initialize do
    total = 0 unless total.blank?
    fully_paid = false if fully_paid.nil?
  end

  def pay
    unless fully_paid
      self.fully_paid = true
      self.cost = self.total
      build_desc
      create_cost
      save
    end
  end

  def build_desc
    if self.desc.blank?
      self.desc = "#{user}于#{DateTime.now}在#{self.locatable}购买"
      arr_desc = []
      bill_prices.each do |bp|
        arr_desc.push "#{bp.price.good}*#{bp.amount}"
      end
      arr_desc.push fully_paid ? "共支付了#{cost}元。" : "支付了其中的#{cost}元。"
      self.desc += arr_desc.join("，")
    end
  end

  def create_cost
    costs.new(
      {
        money: cost,
        user_id: user_id,
        desc: self.desc
      }, on: :bill
      )
  end
  
  def to_s
    "#{locatable}产生的账单"
  end

  before_create do
    ordered_at = DateTime.now if ordered_at.blank?
    unless cost.blank?
      self.fully_paid = true if cost.to_f == total
      build_desc
      create_cost
    end
  end
end
