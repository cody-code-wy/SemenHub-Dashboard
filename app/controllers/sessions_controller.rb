class SessionsController < ApplicationController
  def secure
    false
  end

  def new
    if session[:user_id]
      return redirect_to '/'
    end
  end

  def create
    if session[:user_id]
      return redirect_to '/'
    end
    user = User.find_by_email(params[:email])
    if user and user.password_digest and user.authenticate(params[:password]) and user.can? :login
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
