class City < ActiveRecord::Base
  belongs_to  :province
  has_many    :areas
  has_many    :ips
  has_many    :places
  has_many    :prices
  has_many    :shops
  has_many    :contacts

  geocoded_by :name, latitude: :lat, longitude: :lon
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
