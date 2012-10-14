class Order < ActiveRecord::Base
  attr_accessible :shop_id, :status, :total, :contact_id
  has_many :order_prices
  has_many :prices,through: :order_prices
  has_many :goods,through: :prices
  belongs_to :shop
  belongs_to :user
  belongs_to :contact
  scope :recent,order('updated_at desc')
  def to_s
    "#{Order.model_name.human}##{self.id}"
  end
  after_initialize do
    self.shop_id = Shop.first.id if read_attribute(:shop_id).blank?
  end
end
