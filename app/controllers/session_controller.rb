class SessionController < ApplicationController
  def new
    @session = {sessionid: SecureRandom.uuid}

    $redis.set @session[:sessionid], [].to_json
    $redis.expire @session[:sessionid], $redis_timeout

    render json: @session
  end

end
