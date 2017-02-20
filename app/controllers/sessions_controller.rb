class SessionsController < ApplicationController
  def secure
    false
  end

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to session[:login_redirect] ? session[:login_redirect] : '/'
    else
      redirect_to '/login'
    end

  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end
end
