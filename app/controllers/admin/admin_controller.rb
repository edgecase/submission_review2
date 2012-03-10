class Admin::AdminController < ApplicationController
  before_filter :check_admin
  
  
  private
  def check_admin
    render :status=>:unauthorized, :template=>'/admin/shared/not_admin' unless reviewer.admin
  end
end