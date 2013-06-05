class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :comment
  field :role, default: 'comments'

  #include ActsAsCommentable::Comment

  belongs_to :commentable, polymorphic: true

  #default_scope desc(:created_at)

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user
  scope :recent,desc(:created_at)
end
