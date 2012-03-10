ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'rails/test_help'

require 'flexmock/test_unit'

class String
  alias each each_char
end

class ActiveSupport::TestCase

  # self.use_transactional_fixtures = true
  # fixtures :all
  def logon(twitter = 'mavis', opts={:admin=>false})
    session[:reviewer] = Reviewer.generate(:twitter=>twitter, :admin=>opts[:admin])
  end
  
  def logoff
    session.delete :reviewer
  end
  
end
