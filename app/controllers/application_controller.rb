class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # http_basic_authenticate_with name: "craigp", password: "$r@plQK6a2?mry=B49pE"

  before_action do 
    authorize if secure
  end

  helper_method :current_user, :secure, :perms

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def secure
    true
  end

  def perms
    :superuser
  end

  def authorize
    unless current_user
      session[:login_redirect] = request.original_url if request.get?
      return redirect_to '/login'
    end
    return redirect_to '/401' unless perms.respond_to?(:each) ? current_user.can_all?(perms) : current_user.can?(perms)
  end

end
