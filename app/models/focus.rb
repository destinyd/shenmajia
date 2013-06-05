class Focus
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :focusable, polymorphic: true
  belongs_to :user
  validates :user_id, presence: true,uniqueness: {scope: [:focusable_id,:focusable_type]}
  
  scope :most, select: 'focusable_id,focusable_type,count(*) as count',group: 'focusable_id,focusable_type'
  
  def to_s
    focus.focusable.to_s
  end
  
  def to_most_s
    "#{self.focusable}(#{self.count})"
  end

end
