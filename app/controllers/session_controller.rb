class SessionController < ApplicationController

  def secure
    false
  end

  def new
    @session = {sessionid: SecureRandom.uuid}

    render json: @session
  end

end
