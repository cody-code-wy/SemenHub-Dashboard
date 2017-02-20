class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # http_basic_authenticate_with name: "craigp", password: "$r@plQK6a2?mry=B49pE"

  before_action do 
    authorize if secure
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def secure
    true
  end

  def authorize
    redirect_to '/login' unless current_user
  end
end
