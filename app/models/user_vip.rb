class UserVip < ActiveRecord::Base
  attr_accessible :finish_at, :started_at#, :user_id
  belongs_to :user
  scope :now,where('started_at <= ? and finish_at >= ?',DateTime.now,DateTime.now)
  default_scope order('created_at desc')
end
