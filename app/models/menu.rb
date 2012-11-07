class Menu < ActiveRecord::Base
  attr_accessible :image,:tag_list#,:page
  mount_uploader :image, MenuUploader
  acts_as_taggable

  belongs_to :user
  belongs_to :place#, through: :place_menus
  validates :image, presence: true

  def next 
    @next ||= place.menus.where('menus.id > ?',self.id).order(:id).first || false
  end

  def prev
    @prev ||= place.menus.where('menus.id < ?',self.id).order('id desc').first || false
  end

  def to_s
    I18n.t('model.menu',place_name: place.name,tag: tags.map(&:name).join(','))
  end

  protected
end
