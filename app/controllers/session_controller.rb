class SessionController < ApplicationController
  def new
    @session = {sessionid: SecureRandom.uuid}

    render json: @session
  end

end
