class Msg < ActiveRecord::Base
  #belongs_to :user
  belongs_to :sender,foreign_key:  "user_id", class_name:  "User"
  belongs_to :to_user,foreign_key:  "to", class_name:  "User"
  attr_accessor :to_name
  attr_accessible :to_name,:title,:body
  attr_accessible :to_name,:title,:body,:to,on: :admin

  validates :to_name, presence: true, length: {in: 2..12 }
  validates :title,:body,:to, presence: true

  default_scope order('created_at desc').includes(:sender).includes(:to_user)
  scope :unread,where(is_read: nil)

  def read
    self.update_attribute :is_read,true unless is_read
  end

  before_validation do
    self.to_user = User.find_by_username to_name
    self.errors.add(:to_name,:not_exist) unless self.to_user
    self.errors.add(:to_name,:could_not_self) if self.to_user and self.sender == self.to_user
  end
end
