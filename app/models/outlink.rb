class Outlink
  include Mongoid::Document
  include Mongoid::Timestamps
  STATUS_LOW = 5
  field :url,              :type => String, :default => ""
  field :verified,              :type => Boolean
  belongs_to :outlinkable, polymorphic: true
  belongs_to :user
  def human_link
    read_attribute(:url)
  end
end
