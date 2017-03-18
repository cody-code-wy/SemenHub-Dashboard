class WelcomeController < ApplicationController
  protect_from_forgery with: :exception

  def secure
    false
  end

  def index

  end

end
