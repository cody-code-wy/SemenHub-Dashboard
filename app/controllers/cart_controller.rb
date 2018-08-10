class CartController < ApplicationController
  protect_from_forgery except: :add

  def perms
    :purchase
  end

  def update
    @skus = get_skus
    @skus.each do |sku|
      quantity = get_quantity_param(sku.id)
      if quantity > 0
        $redis.sadd "CART-#{current_user.id}.#{current_user.cart}", sku.id
        $redis.expire "CART-#{current_user.id}.#{current_user.cart}", $redis_timeout
        $redis.set "QUANTITY-#{current_user.id}.#{current_user.cart}-#{sku.id}", quantity
        $redis.expire "QUANTITY-#{current_user.id}.#{current_user.cart}-#{sku.id}", $redis_timeout
      else
        $redis.srem "CART-#{current_user.id}.#{current_user.cart}", sku.id
        $redis.expire "CART-#{current_user.id}.#{current_user.cart}", $redis_timeout
        $redis.del "QUANTITY-#{current_user.id}.#{current_user.cart}-#{sku.id}", quantity
      end
    end
    @quantities = get_quantities
    respond_to do |format|
      format.html {redirect_to cart_path}
      format.json {render :show}
    end
  end

  def show
    @skus = get_cart_skus
    @quantities = get_quantities
  end

  def checkout
    purchase = Purchase.create(user: get_user, state: "created")
    @skus = get_cart_skus
    quantities = get_quantities
    get_cart_skus.each do |sku|
      quantity = quantities[sku.id]
      quantity = sku.quantity if quantity > sku.quantity
      purchase.inventory_transactions << InventoryTransaction.create(quantity: -quantity, sku: sku)
    end
    current_user.cart = SecureRandom.uuid
    redirect_to purchase
  end

  protected

  def get_user
    return current_user unless current_user.can?(:assign_purchase_to_user) and params.dig(:purchase, :target_user)
    User.find(params.require(:purchase).require(:target_user))
  end

  def get_skus
    Sku.where(private: false, id: params.require(:skus).keys)
  end

  def get_cart_skus
    Sku.where(private: false, id: $redis.smembers("CART-#{current_user.id}.#{current_user.cart}"))
  end

  def get_quantity_param sku_id
    params.require(:skus).require("#{sku_id}").to_i
  end

  def get_quantities
    quantities = {}
    @skus.each do |sku|
      quantities[sku.id] = $redis.get("QUANTITY-#{current_user.id}.#{current_user.cart}-#{sku.id}").to_i
    end
    return quantities
  end

end
