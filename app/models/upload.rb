class Upload
  include Mongoid::Document
  include Mongoid::Timestamps
  field :deleted_at,              :type => Date
  field :image_file_name,              :type => String
  field :image_content_type,              :type => String
  field :image_file_size,              :type => Integer
  field :image_updated_at,              :type => Date
  attr_accessible :image,:image_file_name
  mount_uploader :image, ImageUploader, :mount_on => :image_file_name
  belongs_to :uploadable, polymorphic: true
  #has_many :reviews, as: :reviewable
  #acts_as_commentable

  #validates_attachment_size :image, less_than: 2.megabytes
  #validates_attachment_content_type :image, content_type: ['image/jpeg', 'image/png', 'image/gif']

  #validates :image_file_name, presence: true#,uniqueness: {scope: [:uploadable_id, :uploadable_type]}
  #validates :uploadable_type, presence: true
  
  default_scope where(deleted_at: nil)
  scope :recent,desc(:created_at)#.limit(9)
  #scope :review_type, Filter.new(self).extend(ReviewTypeFilter)
 
  #has_attached_file :image, 
                     #styles: { original: '640x3000>',  small: '120x120#',shop:'180x180#' }, 
                     #path: ":rails_root/public/images/items/:style_:id_:updated_at.:extension", 
                     #url: "/images/items/:style_:id_:updated_at.:extension" 

  def destroy
    self.deleted_at = Time.now
    self.save
  end

  def to_s
    if uploadable
      uploadable.to_s
    else
      image_file_name
    end
  end

  after_create do
    if self.uploadable and self.uploadable.methods.include? :image and self.uploadable.image.blank?
      #self.uploadable.write_uploader(:image, read_attribute(:image_file_name))
      self.uploadable.image = self.image
      self.uploadable.save# if self.uploadable.changed?
    end
  end
     
end
