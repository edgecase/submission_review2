class Presenter < ActiveRecord::Base
  self.table_name = 'users'
  has_many :proposals

  def name
    "#{full_name} (#{familiar_name})"
  end

end
