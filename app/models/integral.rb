class Integral
  include Mongoid::Document
  include Mongoid::Timestamps
  field :point,              :type => Integer
  field :desc
  field :type_id,              :type => Integer
  belongs_to :user
  belongs_to :integralable,polymorphic: true
  scope :recent, desc(:created_at)
  scope :exp,where(type_id: 0)
  scope :integral,where(type_id: 1)
  scope :gold,where(type_id: 2)
end
