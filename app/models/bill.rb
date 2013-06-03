# coding: utf-8
class Bill < ActiveRecord::Base
  acts_as_paranoid
  attr_accessor :cost, :desc
  attr_accessible :ordered_at, :total, :bill_prices_attributes, :cost, :desc, :contact_id#,:uploads_attributes
  has_many :bill_prices#, dependent: :destroy
  has_many :prices,through: :bill_prices
  has_many :goods,through: :prices
  has_many :costs, dependent: :destroy
  has_many :uploads, as: :uploadable
  belongs_to :user
  belongs_to :shop
  belongs_to :contact

  accepts_nested_attributes_for :bill_prices, allow_destroy: true
  #accepts_nested_attributes_for :uploads

  scope :recent,order("bills.id desc")
  scope :with_pic,where('bills.picture_count > 0')
  scope :with_bill_prices,includes(:bill_prices)
  scope :with_goods,includes(:goods)

  #for controller
  scope :list,with_goods
  scope :with_bl,with_bill_prices

  after_initialize do
    total = 0 unless total.blank?
    fully_paid = false if fully_paid.nil?
    picture_count = 0 if picture_count.nil?
  end

  def pay
    unless fully_paid
      self.fully_paid = true
      self.cost = self.total
      build_cost_desc
      create_cost
      save
    end
  end

  def to_s
    "账单#{id}"
  end

  include DescBuilder

  def create_cost
    costs.new(
      {
        money: cost,
        user_id: user_id,
        desc: self.desc
      }, on: :bill
      )
  end
  
  before_create do
    ordered_at = DateTime.now if ordered_at.blank?
    unless cost.blank?
      self.fully_paid = true if cost.to_d == total.to_d
      build_cost_desc
      create_cost
    end
  end
end
