# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  before_filter :authenticate

  helper_method :reviewer
  def reviewer=(reviewer)
    session[:reviewer] = reviewer
  end
  
  def reviewer
    session[:reviewer]
  end

private
  def authenticate
    redirect_to new_reviewer_session_path unless session[:reviewer]
  end
end
