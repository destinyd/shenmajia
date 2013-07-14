class Area
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name,              :type => String
  field :lat,              :type => Float
  field :lon,              :type => Float

  belongs_to  :city
end

