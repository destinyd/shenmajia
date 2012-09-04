class Contact < ActiveRecord::Base
  attr_accessible :address, :province_id, :area_id, :city_id, :is_default, :name, :phone, :telephone, :user_id
  belongs_to :user
  belongs_to :city
  belongs_to :area
  belongs_to :province
  has_many :bills

  validates :city_id, :presence => true
  validates :address, :presence => true
  validates :telephone, :presence => true
  validates :name, :presence => true
  scope :default, where(:is_default => true)
  default_scope order('is_default desc')

  before_save :change_default

  after_destroy :select_default

  protected
  def change_default
  	if is_default
  	  dc = self.user.default_contact
  	  dc.update_attribute :is_default, false if dc
  	else
  	  self.is_default = true if self.user.contacts.blank?
  	end
  end

  def select_default
    dc = self.user.default_contact
    unless dc
      f = self.user.contacts.first
      f.update_attribute :is_default, true if f
    end
  end  

end
