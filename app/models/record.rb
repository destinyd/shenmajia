class Record < ActiveRecord::Base
  belongs_to :recordable, :polymorphic => true
  belongs_to :user
end
