class BillPrice < ActiveRecord::Base
  attr_accessible :bill_id, :price_id, :amount
  belongs_to :bill
  belongs_to :price
end
