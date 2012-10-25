class PlaceGood < ActiveRecord::Base
  attr_accessible :good_id, :place_id
  belongs_to :place
  belongs_to :good
end
