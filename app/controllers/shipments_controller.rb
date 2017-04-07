class ShipmentsController < ApplicationController

  def create
    @purchase = Purchase.find(params[:purchase_id])
    @storage = StorageFacility.find_by_address_id(params[:shipment][:address_id])
    @purchase.shipment = Shipment.new(address: @storage.address, location_name: @storage.name, account_name: current_user.get_name )
    if @purchase.storagefacilities.where(admin_required: true).any?
      @purchase.administrative!
      PurchaseMailer.administrative_notice(@purchase).deliver_now
      flash[:alert] = "Your order requires administrative oversight and cannot be processed yet, no action is required on your part. \nYou will recieve an email when you can complete, and pay, for your order. We appologise for any inconvinience."
    else
      @purchase.send_all_emails
      flash[:alert] = "Your order in being processed, you should recieve a receipt shortly."
    end
    redirect_to @purchase
  end

end
