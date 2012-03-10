# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def logoff_link
    link_to 'logoff', reviewer_session_path(session[:reviewer]), {:method=>:delete, :id => 'logout'} if session[:reviewer]
  end
  
  def admin?
    session[:reviewer] && session[:reviewer].admin
  end
end
