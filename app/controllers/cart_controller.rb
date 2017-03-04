class CartController < ApplicationController

  def secure
    false
  end

  def add
    $redis.sadd params[:session], params[:animalid]
    $redis.expire params[:session], $redis_timeout
    render json: $redis.smembers(params[:session])
  end

  def show
    @animals = Animal.find($redis.smembers params[:session])
  end
end
