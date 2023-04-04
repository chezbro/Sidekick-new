class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?
  before_action :authenticate_user!, only: [:users, :conversations, :messages]

  private
  
  def authenticate_user!
    unless current_user
      flash[:error] = "You must be logged in to access this page"
      redirect_to new_user_path
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  

  def user_signed_in?
    !!current_user
  end
end
