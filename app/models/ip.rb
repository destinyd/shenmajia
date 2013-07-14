class Ip
  include Mongoid::Document
  include Mongoid::Timestamps
  field :ip,              :type => String
  field :lat,              :type => Float
  field :lon,              :type => Float

  belongs_to :city
  validates :ip, presence: true,uniqueness: true
  before_create :get_ip
  def city_name
    self.city.try(:name)
  end
  def get_ip
    @get_ip = GetIp.new self.ip
    if @get_ip.city
      @city = City.find_by_name @get_ip.city
    else
      @city = City.first
    end
    self.city,self.lat,self.lon = @city,@city.lat,@city.lon if @city
  end
end
