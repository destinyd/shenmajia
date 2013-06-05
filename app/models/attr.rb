class Attr
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name,              :type => String
  field :value,              :type => String
  field :supported,              :type => Boolean
  belongs_to :attrable, polymorphic: true
  validates :name,presence: true
  validates :value,presence: true
  #validates :attrable_id,presence: true
  #validates :attrable_type,presence: true
  scope :supported,where(supported: true)

  before_create  :supported_first
  private
  def supported_first
    first = Attr.where(name: self.name).limit(1)
    self.supported = true if first.blank?
  end
end
