class CartController < ApplicationController
  protect_from_forgery except: :add

  def secure
    params[:action] != 'add'
  end

  def perms
    :purchase
  end

  def add
    $redis.sadd params[:session], params[:animalid]
    $redis.expire params[:session], $redis_timeout
    @animal = Animal.find(params[:animalid])
    render json: {animal: @animal, redis: $redis.smembers(params[:session])}, callback: params[:callback]
  end

  def show
    @animals = Animal.where(id: $redis.smembers(params[:session]))
  end

  def checkout
    purchase = Purchase.create(user: get_user , state: "created")
    get_sku_params.each do |a|
      skus = a[0].similar
      count = a[1]
      skus.each do |sku|
        next if count <= 0 #just incase it becomes negitive somehow
        if count <= sku.quantity
          purchase.inventory_transactions << InventoryTransaction.create(quantity: -count, sku: sku)
          count = 0; #thats it we are done
        else
          count -= sku.quantity #take all of them
          purchase.inventory_transactions << InventoryTransaction.create(quantity: -sku.quantity, sku: sku) if sku.quantity < 0
        end
      end
      if count > 0
        #Couldent get everything they wanted!
        # TODO warn the user somehow
      end
    end
    $redis.del(params[:cart_id])
    redirect_to purchase
  end

  protected

  def get_user
    return current_user unless current_user.can?(:assign_purchase_to_user) and params[:purchase][:user_id]
    User.find(params.require(:purchase).require(:user_id))
  end

  def get_sku_params
    params.require(:skus).permit!.to_h.map{|k,v| [Sku.find(k), v.to_i]}.delete_if { |a| a[1] == 0  }
  end

end
