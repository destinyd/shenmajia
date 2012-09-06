class Upload < ActiveRecord::Base
  belongs_to :uploadable, polymorphic: true
  has_many :reviews, as: :reviewable
  acts_as_commentable

  validates_attachment_size :image, less_than: 1.megabytes
  validates_attachment_content_type :image, content_type: ['image/jpeg', 'image/png', 'image/gif']

  validates :image_file_name, presence: true,uniqueness: {scope: [:uploadable_id, :uploadable_type]}
  
  default_scope where(deleted_at: nil).order('id desc')
  scope :recent,limit(9)
  scope :review_type, Filter.new(self).extend(ReviewTypeFilter)
 
  has_attached_file :image, 
                     styles: { original: '250x250>',  small: '120x120>' }, 
                     path: ":rails_root/public/images/items/:style_:id_:updated_at.:extension", 
                     url: "/images/items/:style_:id_:updated_at.:extension" 

  def destroy
    self.deleted_at = Time.now
    self.save
  end
     
end
