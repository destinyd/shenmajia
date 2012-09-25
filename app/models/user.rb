class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:username
  
  has_many :prices
  has_many :comments
  has_many :goods
  has_many :integrals
  has_many :msgs
  has_many :got_msgs, class_name: "Msg",foreign_key: 'to'
  has_many :articles
  has_many :uploads
  has_many :focuss
  has_many :outlinks
  has_many :records
  has_many :user_tasks
  has_many :tasks,through: :user_tasks
  has_many :shops
  #has_many :user_costs
  has_many :costs#,through: :user_costs
  has_many :bills
  has_many :companies
  has_many :brands
  has_many :products
  has_many :norms
  has_many :units
  has_many :contacts

  validates :username, presence: true,uniqueness: true, length: {in: 3..12 }


  scope :recent ,limit(10).order('id desc')#.select('email,created_at')

  def default_contact
    contacts.default.first
  end

  def to_s
    self.username || self.email
  end
  def get_point(point,integralable,type_id = 0,desc = nil)
    integral = self.integrals.new point: point,desc: desc,type_id: type_id
    integral.integralable = integralable
    integral.save!
  end

  def points type_id = 0
    self.integrals.sum(:point).where(type_id: type_id)
  end
end
