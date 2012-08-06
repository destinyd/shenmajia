# coding: utf-8
class Bill < ActiveRecord::Base
  attr_accessible :locatable_id, :locatable_type, :ordered_at, :total
  has_many :bill_prices
  has_many :prices,:through => :bill_prices
  has_many :costs
  has_many :uploads, :as => :uploadable
  belongs_to :locatable, :polymorphic => true

  scope :recent,order("bills.id desc")
  
  def to_s
    "#{locatable}产生的账单##{id}"
  end

  before_create do
    ordered_at = DateTime.now if ordered_at.blank?
  end
end
