# coding: utf-8
class Price < ActiveRecord::Base
  acts_as_paranoid
  STATUS_LOW = 5
  mount_uploader :image, ImageUploader
  attr_accessor :good_name,:good_user_id,:original_price,:is_cheap_price,:is_360,:name,:title, :place_ids
  attr_accessible :price,:type_id,:address,:amount,:good_name,:finish_at,:started_at,:name,:good_attributes,:outlinks_attributes,:lon, :lat,:original_price,:is_cheap_price,:is_360,:title,:image,:good_id,:city_id,:image, :place_ids#,:uploads_attributes
  attr_accessible :user_id, on: :bill
  attr_accessible :locatable_type,:locatable_id,:image_path, on: :admin
  #validates :type_id, presence: true
  validates :price, presence: true
  #validates :good_id, presence: true
  belongs_to :user
  belongs_to :good
  belongs_to :city
  #belongs_to :shop

  has_many :outlinks, as: :outlinkable, dependent: :destroy
  has_many :integrals, as: :integralable#, dependent: :destroy
  has_many :reviews, as: :reviewable#, dependent: :destroy
  #has_many :uploads, as: :uploadable#, dependent: :destroy
  has_many :inventories
  #has_many :price_costs,dependent: :destroy
  #has_many :costs,through: :price_costs
  #has_many :costs
  belongs_to :locatable, polymorphic: true

  has_many :bill_prices#, dependent: :destroy
  has_many :bills,through: :bill_prices

  has_many :order_prices
  has_many :orders,through: :order_prices

  acts_as_commentable
  geocoded_by :address, latitude: :lat, longitude: :lon

  scope :review_type, Filter.new(self).extend(ReviewTypeFilter)
  scope :review_low, Filter.new(self).extend(ReviewFilter)
  scope :truth,review_low(Review.truth_point)

  scope :running,where("finish_at > ? OR finish_at is null",Time.now)
  scope :cheapest,running.order("price")
  scope :recent,running.order("id desc")
  scope :groupbuy,recent.where(type_id: [21,22])
  scope :not_finish,where("finish_at > ?",Time.now)
  # scope :costs,recent.where(type_id: [0,1])  
  scope :with_good,includes(:good)
  scope :with_locatable,includes(:locatable)
  scope :you_like,running.order('rand()')
  scope :shop_type, where(type_id: 101..103)
  scope :shop_price, lambda {|shop| recent.shop_type.where(locatable_type: 'Shop', locatable_id: shop.id)}
  scope :with_pic,where('prices.image is not null')
  scope :in_city,with_pic.includes(:good)
  scope :in_action,lambda{|action_name|
    if %w{cheapest groupbuy}.include? action_name
      eval(action_name)
    else
      scoped
    end
  }
  scope :list,with_good.with_locatable.recent
  scope :just_ten,limit(10)

  scope :in_place,with_good.order('type_id desc').recent#.group('good_id')
  scope :tuijian,recent.with_pic.list.limit(6).group(:good_id)


  accepts_nested_attributes_for :good,reject_if: lambda { |good| good[:name].blank? }
  #accepts_nested_attributes_for :uploads
  accepts_nested_attributes_for :outlinks, reject_if: lambda { |outlink| outlink[:url].blank? }, allow_destroy: true

  TYPE = {
  0=>'消费',
  1=>'网上消费',
  6=>'特价',
  7=>'商品标示原价',
  11=>'商家叫价',
  21=>'团购价',
  22=>'全国配送团购价',
  31=>'批发价',
  51=>'成本价',
  101=>'商店发布价',
  102=>'商店特价',
  103=>'商店秒杀价'
  }

  def no_locate?
    self.lon.blank? or self.lat.blank?
  end

  def type_id
    t = read_attribute(:type_id)
    TYPE[t]
  end

  #def type_id=(value)
    #write_attribute(:type_id, TYPE.key(value))
  #end

  def human_price
    #return self.price.to_s + '元' + '(待审)' if self.type_id !='团购价' or self.is_valid.nil?# and self.reviews.sum(:status) < STATUS_LOW
    self.price == 0.0 ? "免费" :"#{"%0.2f" %self.price}元"
  end

  def human_amount
    return '不限量' if amount.nil?
    amount 
  end

  def human_finish_at
    return '不限时' if finish_at.nil?
    finish_at
  end

  def self.types
    TYPE
  end

  def self.shop_types
    [TYPE[101],TYPE[102],TYPE[103]]
  end

  def self.selects
    TYPE.select{|k,v|k<31}.invert
  end

  def valid
    return if is_valid
    update_attribute(:is_valid, true)
    user.get_point(1,self,1) if user_id
  end

  def exp
    user.get_point(1,self) if user_id
  end

  # def deal_cheap_price
  #   create_alias_price 6,price if !is_cheap_price.blank? and is_cheap_price != "0"
  # end

  # def deal_original_price
  #   create_alias_price 7,original_price unless original_price.blank?
  # end

  # def create_alias_price type_id,price
  #   p = Price.new title: title,
  #     type_id: type_id,
  #     price: price,
  #     address: address,
  #     lat: lat,
  #     lon: lon,
  #     amount: amount
  #   outlinks.each do |outlink|
  #     o = Outlink.new url: outlink.url
  #     o.user_id = outlink.user_id
  #     p.outlinks << o
  #   end
  #   p.user_id = user_id
  #   p.save
  # end

  def near_prices long = 20
    return city.prices.where("id != ?",self.id) if city_id
    return if no_locate?
    @nears ||= nearbys(long)
    @nears ||= @nears.running.limit(10) unless @nears == []
    @nears
  end

  def self.near_prices coordinates,long = 20
    Price.near(coordinates,long).running.limit(10)
  end

  def to_s
    #if name
      #case type_id
      #when '团购价'
        #name
      #when '全国配送团购价'
        #name
      #else
        #"(#{human_price})#{name}"
      #end 
    #else
      #""
    #end
    "#{human_price}(#{type_id})"
  end

  def human_name
    if name
      case type_id
      when '团购价'
        name
      when '全国配送团购价'
        name
      else
        "(#{human_price})#{name}"
      end 
    else
      ""
    end 
  end

  def could_post_good? user
    user and !goods.map(&:user_id).include?(user.id)
  end

  def is_tuangou?
    [21,22].include? read_attribute(:type_id)
  end

  def name
    good.name if good
  end

  def desc 
    good.desc
  end

  def finish
    self.update_attribute :finish_at, DateTime.now if self.finish_at.nil? and  self.inventories.length == 1
  end

  def image_path= obj
    write_uploader :image,obj
  end

  def image_path
    read_attribute(:image)
  end

  include PosHelper

  # before_validation :init_type_id
  before_create :locate_city, :locate_pos #:locate_by_city
  # before_create :geocode, if: [:no_locate?,:address_changed?]#,on: :create
  #before_update :geocode, if: :address_changed?
  before_create :outlink_user
  after_create :exp,:deal_good,:deal_image,:deal_place_ids
  # after_create :deal_cheap_price,:deal_original_price


  protected
  def outlink_user
    outlinks.each do |outlink|
      outlink.user_id = user_id
    end
  end
  
  def deal_place_ids
    unless place_ids.blank?
      place_ids.split(',').each do |p_id|
        if @place = Place.where(id: p_id).first
          Price.delay.create({
            price: self.price,
            type_id: self.read_attribute(:type_id),
            started_at: self.started_at,
            finish_at: self.finish_at,
            good_id: self.good_id,
            lat: @place.lat,
            lon: @place.lon,
            city_id: self.city_id,
            locatable_type: self.locatable_type,
            locatable_id: p_id,
            image_path: self.image_path
          },on: :admin
          )
        end
      end
    end
  end

  # def locate_by_city
  #   if self.user_id.nil? and self.no_locate? and ! self.city.blank?
  #     if @locate = Locate.where(name: self.city).first_or_create
  #       self.lat = @locate.lat
  #       self.lon = @locate.lon
  #     end
  #   end
  # end

  def locate_city
    self.city_id = locatable.city_id if self.city_id.blank? and locatable
  end

  def locate_pos
    if locatable.class.name == 'Place'
      self.pos = locatable.lat,locatable.lon
    elsif locatable.class.name == 'Shop'
      self.pos = locatable.locatable.pos if locatable.locatable
    end if no_locate? and locatable
    self.pos = city.pos if no_locate? and city
  end  
  
  def deal_good
    return if good_id
    tmp = Good.where(name: title).first_or_create
    self.good_id = tmp.id  unless self.good_id
    save if changed?
  end

  def deal_image
    return if image.blank?
    u = good.uploads.new
    u.image_file_name =  self.read_attribute(:image)
    u.save
    #self.good_id = tmp.id  unless self.good_id
    #save if changed?
  end

  after_initialize do
    self.type_id = 0 if read_attribute(:type_id).blank?
  end
end
