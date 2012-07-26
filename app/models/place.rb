class Place < ActiveRecord::Base
  attr_accessible :addr, :guid, :lat, :lon, :name, :tel, :mayor_description, :has_event, :has_surprise, :has_mayor_coupon,:categories,:link,:dist
  attr_accessor :mayor_description, :has_event, :has_surprise, :has_mayor_coupon,:categories,:dist
  validates :guid, :presence => true,:uniqueness => true 
  validates :name, :presence => true,:uniqueness => {:scope => [:lat,:lon]}
  #validates :name, :presence => true,:uniqueness => true
  validates :lat, :presence => true, :numericality => {:greater_than_or_equal_to => -90, :less_than_or_equal_to => 90}
  validates :lon, :presence => true, :numericality => {:greater_than_or_equal_to => -180, :less_than_or_equal_to => 180}

  require 'locate_validator'
  validates_with LocateValidator

  has_many :shops
  has_many :place_goods,:dependent => :destroy
  has_many :goods,:through => :place_goods
  has_many :costs, :as => :locatable, :dependent => :destroy
  has_many :prices, :as => :locatable, :dependent => :destroy
  
  scope :recent,order("id desc")

  include UuidHelper
  #set_primary_key :guid
  #before_create :init_guid
  #protected
  #def init_guid
    #self.guid = Guid.new.hexdigest.upcase
  #end
  #def to_params
    #self.guid
  #end
  def to_s
    self.name
  end

  geocoded_by :addr, :latitude  => :lat, :longitude => :lon
  def near_places long = 20
    @nears ||= nearbys(long)
    @nears = @nears.limit(10) unless @nears == []
    @nears
  end
end
