# coding: utf-8
class Bill
  include Mongoid::Document
  include Mongoid::Timestamps
  field :total,              :type => Float
  field :ordered_at,              :type => Date
  field :fully_paid,              :type => Boolean
  field :ordered_at,              :type => Date
  field :deleted_at,              :type => Date
  field :picture_count,              :type => Integer, default: 0
  field :desc,              :type => String
  field :address,              :type => String
  field :lat, :type => Float
  field :lon, :type => Float

  #acts_as_paranoid
  attr_accessor :cost, :desc
  attr_accessible :ordered_at, :total, :bill_prices_attributes, :cost, :desc, :address, :lat, :lon
  has_many :bill_prices#, dependent: :destroy
  #has_many :prices,through: :bill_prices
  #has_and_belongs_to_many :prices
  #has_many :goods,through: :prices
  has_many :costs, dependent: :destroy
  has_many :uploads, as: :uploadable
  belongs_to :user

  validates :total, presence: true

  #accepts_nested_attributes_for :bill_prices, allow_destroy: true
  #accepts_nested_attributes_for :uploads
  accepts_nested_attributes_for :bill_prices, :allow_destroy => true, :reject_if => proc { |attributes| attributes['price_value'].blank? || attributes['amount'].blank? }

  scope :recent,desc(:updated_at)
  scope :with_pic,where(:picture_count.gt => 0)
  scope :with_bill_prices,includes(:bill_prices)
  #scope :with_goods,includes(:goods)

  #for controller
  #scope :list,with_goods
  scope :with_bl,with_bill_prices

  after_initialize do
    total = 0 unless total.blank?
    fully_paid = false if fully_paid.nil?
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

  def prices
    Price.in(id: bill_prices.map(&:id))
  end
  
  before_create do
    ordered_at = DateTime.now if ordered_at.blank?
    unless cost.blank?
      self.fully_paid = true if cost.to_f == total.to_f
      build_cost_desc
      create_cost
    end
  end

  after_create :calc_pic_count

  def calc_pic_count
    bill_prices.each do |bp|
      self.picture_count += 1 if !bp.image.blank?
    end
    save if changed?
  end
end
