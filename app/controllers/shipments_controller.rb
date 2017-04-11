class ShipmentsController < ApplicationController

  def perms
    return :purchase
  end

  def create
    @purchase = Purchase.find(params[:purchase_id])
    @storage = StorageFacility.find_by_address_id(params[:shipment][:address_id])
    @purchase.shipment = Shipment.new(address: @storage.address, location_name: @storage.name, account_name: @purchase.user.get_name )
    @purchase.create_line_items
    if @purchase.shipment.address.alpha_2 != 'us' || @purchase.storagefacilities.where(admin_required: true).any?
      @purchase.administrative!
      PurchaseMailer.administrative_notice(@purchase).deliver_now
      flash[:alert] = "Your order requires administrative oversight and cannot be processed yet, no action is required on your part. \nYou will recieve an email when you can complete, and pay, for your order. We appologise for any inconvinience."
    else
      @purchase.invoiced!
      PurchaseMailer.invoice(@purchase).deliver_now
    end
    redirect_to @purchase
  end

end
