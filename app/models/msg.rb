class Msg < ActiveRecord::Base
  belongs_to :user
  belongs_to :getable,foreign_key:  "to", class_name:  "User"
  attr_accessor :to_name
  attr_accessible :to_name,:title,:body

  validates :to_name, presence: true, length: {in: 2..12 }
  validates :title, presence: true
  validates :body, presence: true
  validates :to, presence: true

  default_scope includes(:user).includes(:getable)
  scope :unread,where(is_read: nil)

  def from
    user
  end

  def to_user
    getable
  end

  def read
    self.update_attribute :is_read,true unless is_read
  end

  before_validation do
    getable = User.find_by_username to_name
    if getable 
      if user == getable
        self.errors.add(:to_name,:could_not_self)
      else
        self.to = getable.id 
      end
    else
      self.errors.add(:to_name,:not_exist)
    end
  end
end
