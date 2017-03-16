class PurchasesController < ApplicationController

  def perms
    return super unless ["show"].include?(params[:action])
    :purchase
  end

  def show
    @purchase = Purchase.find(params[:id])
    @purchase.build_shipment if @purchase.shipment.blank?
    @partial = @purchase.state if lookup_context.exists?(@purchase.state, _prefixes, true)
  end


end
