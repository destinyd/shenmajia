class Province < ActiveRecord::Base
  has_many :cities
  has_many :contacts
  
  geocoded_by :name, :latitude  => :lat, :longitude => :lon
  #after_validation :geocode
end
