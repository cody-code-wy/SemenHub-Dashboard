class CartController < ApplicationController
  protect_from_forgery except: :add

  def secure
    params[:action] != 'add'
  end

  def add
    $redis.sadd params[:session], params[:animalid]
    $redis.expire params[:session], $redis_timeout
    render json: $redis.smembers(params[:session]), callback: params[:callback]
  end

  def show
    @animals = Animal.where(id: $redis.smembers(params[:session]))
  end

  def checkout
    purchase = Purchase.create(user: current_user, state: "created")
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
          purchase.inventory_transactions << InventoryTransaction.create(quantity: -sku.quantity, sku: sku)
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

  def get_sku_params
    params.require(:skus).permit!.to_h.map{|k,v| [Sku.find(k), v.to_i]}.delete_if { |a| a[1] == 0  }
  end

end
