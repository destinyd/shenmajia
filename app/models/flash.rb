class Flash
  include Mongoid::Document
  include Mongoid::Timestamps
  field :image_file_name,              :type => String, :default => ""
  field :image_content_type,              :type => String, :default => ""
  field :image_file_size,              :type => Integer
  field :image_updated_at,              :type => Date
  field :url,              :type => String, :default => ""
  #acts_as_commentable
  #acts_as_taggable
  mount_uploader :image, FlashUploader, :mount_on => :image_file_name

  has_one :outlink, as:  :outlinkable
  scope :recent,desc(:id).limit(5)
  scope :list,recent.includes(:outlink)
  accepts_nested_attributes_for :outlink

end
