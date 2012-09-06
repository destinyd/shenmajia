class PlaceSearch < ActiveRecord::Base
  attr_accessor :page
  attr_accessible :city, :q, :lat, :lon,:page
  validates :q, presence: true
  def self.already_got args
    p_args = args.merge(created_at: DateTime.now.beginning_of_month..DateTime.now.end_of_month)
    p_args.delete(:page)
    got = where(p_args).first
    return true if got
    false
  end
end
