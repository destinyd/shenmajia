class ShopContact < ActiveRecord::Base
  attr_accessible :phone, :qq
  belongs_to :shop
end
