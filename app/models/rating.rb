class Rating < ActiveRecord::Base
  belongs_to :proposal
  belongs_to :reviewer
end
