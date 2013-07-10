# coding: utf-8
class Article# < ActiveRecord::Base
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title,              :type => String
  field :content,              :type => String
  field :is_top,              :type => Boolean
  field :is_valid,              :type => Boolean
  belongs_to :user

  STATUS_LOW = 2
  #acts_as_commentable

  validates :title, presence: true,uniqueness: true

  default_scope order_by('is_top' => -1,'id' => -1)
  scope :recent,desc(:updated_at)
  #scope :review_type, Filter.new(self).extend(ReviewTypeFilter)
  #scope :review_low, Filter.new(self).extend(ReviewFilter)
  #scope :truth,review_low(Review.truth_point)

  #has_many :integrals, as: :integralable


  def to_s
    self.title
  end

  def valid
    return if self.is_valid
    self.update_attribute(:is_valid, true)
    self.user.get_point(3,self)
  end
end
