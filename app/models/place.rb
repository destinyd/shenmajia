class Place < ActiveRecord::Base
  attr_accessible :address, :guid, :lat, :lon, :name, :tel, :mayor_description, :has_event, :has_surprise, :has_mayor_coupon, :categories, :link, :dist, :city_id, :addr, :city
  attr_accessor :mayor_description, :has_event, :has_surprise, :has_mayor_coupon, :dist

  store :jiepang , accessors: [ 'mayor_id', 'checkin_users_num', 'checkin_num', 'mayor', 'categories', :photos ]

  #validates :guid, :presence => true
  #validates :guid, :uniqueness => true, :on => :create
  validates :name, :presence => true
  validates :name, :uniqueness => {:scope => [:lat,:lon]}, :on => :create
  validates :address, :presence => true
  #validates :name, :presence => true,:uniqueness => true
  validates :lat, :presence => true, :numericality => {:greater_than_or_equal_to => -90, :less_than_or_equal_to => 90}
  validates :lon, :presence => true, :numericality => {:greater_than_or_equal_to => -180, :less_than_or_equal_to => 180}

  require 'locate_validator'
  validates_with LocateValidator

  belongs_to :city
  has_many :shops
  has_many :place_goods,:dependent => :destroy
  has_many :goods,:through => :place_goods
  has_many :costs, :as => :locatable, :dependent => :destroy
  has_many :prices, :as => :locatable, :dependent => :destroy
  
  scope :recent,order("id desc")

  #include UuidHelper
  before_create do
    self.guid ||= Guid.new.hexdigest.upcase
  end
  #set_primary_key :guid
  #before_create :init_guid
  #protected
  #def init_guid
    #self.guid = Guid.new.hexdigest.upcase
  #end
  #def to_params
    #self.guid
  #end
  def update_jiepang
    if updated_at == created_at or DateTime.now > updated_at + 1.month
      require 'jiepang'
      @jiepang = Jiepang.new
      @j = @jiepang.locations_show self.guid
      @photos = @jiepang.locations_photos self.guid
      self.checkin_num = @j['checkin_num']
      self.checkin_users_num = @j['checkin_users_num']
      self.categories = @j['categories']
      self.photos = @photos['items']
      self.city = @city if updated_at == created_at and city_id.nil? and !@j['city'].blank? and  @city = City.find_by_name(@j['city'])
      unless @j['mayor'].blank?
        self.mayor = @j['mayor']
        self.mayor_id = @j['mayor_id']
      end
      self.save
    end
  end

  def addr
    address
  end

  def addr=(str)
    self.address = str
  end

  def city=(obj)
    case obj.class.name
    when 'City'
      write_attribute :city_id,obj.id
    when 'String'
      write_attribute :city_id, City.find_by_name(obj).try(:id)
    end      
  end

  def to_s
    self.name
  end

  def no_locate?
    self.lat.nil? or self.lon.nil?
  end

  geocoded_by :address, :latitude  => :lat, :longitude => :lon
  def near_places long = 20
    @nears ||= nearbys(long)
    @nears = @nears.limit(10) unless @nears == []
    @nears
  end
end
