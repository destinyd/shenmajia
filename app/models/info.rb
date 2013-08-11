class Info
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :good
  field :provider, type: String
  field :result, type: String
  scope :with_result, where(:result.nin => ['false',''])
end
