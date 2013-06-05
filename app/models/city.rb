require "geocoder/models/mongoid" if defined?(::Mongoid)
class City
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,              :type => String
  field :sort,              :type => Integer
  field :lat,              :type => Float
  field :lon,              :type => Float
  field :coordinates, :type => Array
  belongs_to  :province
  has_many    :areas
  has_many    :ips
  has_many    :prices
  has_many    :shops
  has_many    :contacts

  #include Geocoder::Model::Mongoid
  #geocoded_by :name, latitude: :lat, longitude: :lon
  #after_validation :geocode
  # def shops
  #   Shop.near(self,20)
  # end
  def to_param
    self.name
  end
  def to_s
    self.name
  end
  include PosHelper

  def self.search(search)
    unless search.blank?
      where('name LIKE ?', "%#{search}%").page 1
    else
      scoped.page 1 
    end
  end
end
