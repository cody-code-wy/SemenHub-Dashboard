class ShipmentsController < ApplicationController

  def create
    @purchase = Purchase.find(params[:purchase_id])
    @storage = StorageFacility.find_by_address_id(params[:shipment][:address_id])
    @purchase.shipment = Shipment.new(address: @storage.address, account_name: current_user.get_name )
    @purchase.administrative!
    flash[:alert] = "Your order requires administrative oversight and cannot be processed yet, no action is required on your part. \nYou will recieve an email when you can complete, and pay, for your order. We appologise for any inconvinience."
    redirect_to @purchase
  end

end
