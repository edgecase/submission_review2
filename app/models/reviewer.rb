class Reviewer < ActiveRecord::Base
  has_many :ratings
end
