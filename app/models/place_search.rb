class PlaceSearch
  include Mongoid::Document
  include Mongoid::Timestamps
  field :q
  field :city
  field :coordinates, :type => Array

  #include Geocoder::Model::Mongoid
  #geocoded_by :address, latitude: :lat, longitude: :lon

  attr_accessor :page
  attr_accessible :city, :q, :lat, :lon,:page
  validates :q, presence: true
  def self.already_got args
    p_args = args.merge(created_at: DateTime.now.beginning_of_month..DateTime.now.end_of_month)
    p_args.delete(:page)
    p_args.delete(:source)
    p_args.delete(:count)
    got = where(p_args).first
    return true if got
    false
  end
end
