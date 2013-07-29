# coding: utf-8
module DescBuilder
  def build_cost_desc
    if self.desc.blank?
      self.desc = "我在#{self.address}：购买"
      arr_desc = []
      bill_prices.each do |bp|
        arr_desc.push "#{bp.price.good}*#{bp.amount}#{bp.price.good.unit}=#{'%.2f' % (bp.price.price * bp.amount)}元"
      end
      tmp = arr_desc.join("，")
      tmp = tmp.block 80,"...共#{self.bill_prices.length}件商品" if tmp.length > 80
      self.desc += tmp
      self.desc += self.fully_paid ? "，支付了#{cost}元。" : "，支付了其中的#{cost}元。"
    end
  end
end
