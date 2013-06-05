class Province
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name
  field :remark
  field :sort, :type => Integer
  field :coordinates, :type => Array

  #include Geocoder::Model::Mongoid
  #geocoded_by :name, latitude: :lat, longitude: :lon
  has_many :cities
  
  geocoded_by :name, latitude: :lat, longitude: :lon
  #after_validation :geocode
end
