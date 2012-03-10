class User < ActiveRecord::Base
  has_many :presentations, :foreign_key => :presenter_id
  has_many :proposals, :through => :presentations

  def name
    "#{first_name} #{last_name}"
  end

end
