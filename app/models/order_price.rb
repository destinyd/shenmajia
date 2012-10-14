class OrderPrice < ActiveRecord::Base
  attr_accessible :amount, :order_id, :price_id
  belongs_to :order
  belongs_to :price
end
