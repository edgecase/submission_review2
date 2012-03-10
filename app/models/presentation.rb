class Presentation < ActiveRecord::Base
  belongs_to :proposal
  belongs_to :presenter, :class_name => 'User'
end
