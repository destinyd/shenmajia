class CostBuildBill < ActiveRecord::Migration
  def up
    Cost.all.each do |cost|
      bill = cost.user.bills.new :total => cost.money, :locatable_type => cost.locatable_type, :locatable_id => cost.locatable_id, :ordered_at => cost.created_at
      bill.bill_prices.new :price_id => cost.price_id, :amount => cost.amount
      bill.costs << cost
      bill.save
    end

  end

  def down
  end
end
