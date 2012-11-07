class Place < ActiveRecord::Base
  attr_accessible :address, :guid, :lat, :lon, :name, :tel, :mayor_description, :has_event, :has_surprise, :has_mayor_coupon, :categories, :link, :dist, :city_id, :addr, :city
  attr_accessor :mayor_description, :has_event, :has_surprise, :has_mayor_coupon, :dist

  store :jiepang , accessors: [ 'mayor_id', 'checkin_users_num', 'checkin_num', 'mayor', 'categories', :photos ]

  #validates :guid, presence: true
  #validates :guid, uniqueness: true, on: :create
  validates :name, presence: true
  validates :name, uniqueness: {scope: [:lat,:lon]}, on: :create
  validates :address, presence: true
  #validates :name, presence: true,uniqueness: true
  validates :lat, presence: true, numericality: {greater_than_or_equal_to: -90, less_than_or_equal_to: 90}
  validates :lon, presence: true, numericality: {greater_than_or_equal_to: -180, less_than_or_equal_to: 180}

  require 'locate_validator'
  validates_with LocateValidator

  belongs_to :city
  belongs_to :user
  belongs_to :admin,class_name: 'User',readonly: true
  has_many :shops, as: :locatable, dependent: :destroy
  has_many :place_goods,dependent: :destroy
  has_many :goods,through: :place_goods, :uniq => true
  #has_many :costs, as: :locatable, dependent: :destroy
  has_many :bills, as: :locatable, dependent: :destroy
  has_many :costs, through: :bills, dependent: :destroy
  has_many :prices, as: :locatable, dependent: :destroy
  has_many :uploads, as: :uploadable

  has_many :menus
  
  scope :recent,order("id desc")
  scope :order_city_id,order("city_id desc")
  scope :square,lambda{|sw,ne|
    where("places.lat >= ? and places.lon >= ? and places.lat <= ? and places.lon <= ?",sw[0],sw[1],ne[0],ne[1])
  }

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
      return self.touch if self.guid.blank?
      require 'jiepang'
      @jiepang = Jiepang.new
      @j = @jiepang.locations_show self.guid
      @photos = @jiepang.locations_photos self.guid
      self.checkin_num = @j['checkin_num']
      self.checkin_users_num = @j['checkin_users_num']
      self.categories = @j['categories']
      unless @photos['items'].blank?
        @photos['items'].each do |photo|
          photo['user'].delete 'birthday'
        end
        self.photos = @photos['items']
      end
      self.city = @j['city'] if self.city_id.blank? and !@j['city'].blank? 
      unless @j['mayor'].blank?
        self.mayor = @j['mayor']
        self.mayor_id = @j['mayor_id']
      end
      begin
        self.save
      rescue Exception => e
      end
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

  def self.already_got args
    PlaceSearch.already_got args
  end

  def self.search(args={})
    unless already_got(args)
      require 'jiepang'
      Jiepang.search args
    end
    PlaceSearch.where(args).create
    return where('name LIKE ?', "%#{args[:q]}%").where(city_id: [City.find_by_name(args[:city]).try(:id),nil]) unless args[:city].blank?
    where('name LIKE ?', "%#{args[:q]}%") if  args[:city].blank?
  end


  include PosHelper

  geocoded_by :address, latitude: :lat, longitude: :lon
  def near_places long = 20
    @nears ||= nearbys(long)
    @nears = @nears.limit(10) unless @nears == []
    @nears
  end
end
