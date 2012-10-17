class Order < ActiveRecord::Base
  #status{
  #0:new -> 11 -> 51 -> 52
  #11:paid -> 101
  #51:user cancel
  #52:shop cancel
  #101: done
  #}
  attr_accessible :shop_id, :contact_id
  has_many :order_prices
  has_many :prices,through: :order_prices
  has_many :goods,through: :prices
  belongs_to :shop
  belongs_to :user
  belongs_to :contact
  scope :recent,order('updated_at desc')
  scope :index,includes(:goods)

  def to_s
    "#{Order.model_name.human}##{self.id}"
  end

  def pay
    status_change 11,[0]
  end

  def user_cancel
    status_change 51,[0]
  end

  def shop_cancel
    status_change 52,[0]
  end

  def receive
    status_change 101,[11]
  end

  after_initialize do
    self.shop_id = Shop.first.id if read_attribute(:shop_id).blank?
    self.status=0 if self.status.blank?
  end

  before_create do
    if self.total.blank?
      self.total = 0.0
      self.order_prices.each do |order_price|
        self.total += order_price.amount * order_price.price.price
      end 
    end
  end
  
  private
  def status_change to,from=[]
    unless from.include? self.status
      self.errors.add(:status,:status_change_fault)
      return false
    end
    self.status = to
    save
  end
end
