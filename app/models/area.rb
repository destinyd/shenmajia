class Area < ActiveRecord::Base
  has_many :contacts	
  belongs_to  :city
end

