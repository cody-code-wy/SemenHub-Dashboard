class ShipmentsController < ApplicationController

  def perms
    return :purchase
  end

  def secure
    return true unless ['show', 'update'].include?(params[:action])
    return false
  end

  def create
    @purchase = Purchase.find(params[:purchase_id])
    @storage = StorageFacility.find_by_address_id(params[:shipment][:address_id])
    # @purchase.shipment = Shipment.new(address: @storage.address, location_name: @storage.name, account_name: @purchase.user.get_name )
    create_shipments(@purchase, @storage)
    @purchase.create_line_items
    if @purchase.storagefacilities.where(admin_required: true).any? || @purchase.shipments.where(address: Address.where.not(alpha_2: 'us')).count > 0 || @purchase.shipments.where(origin_address: Address.where.not(alpha_2: 'us')).count > 0
      @purchase.administrative!
      PurchaseMailer.administrative_notice(@purchase).deliver_now
      flash[:alert] = "Your order requires administrative oversight and cannot be processed yet, no action is required on your part. \nYou will recieve an email when you can complete, and pay, for your order. We appologise for any inconvinience."
    else
      @purchase.invoiced!
      PurchaseMailer.invoice(@purchase).deliver_now
    end
    redirect_to @purchase
  end

  def show
    @shipment = Shipment.find(params[:id])
  end

  def update
    @shipment = Shipment.find(params[:id])
    @shipment.update(shipment_update_params)
    redirect_to [@shipment.purchase, @shipment] unless current_user&.superuser?
    redirect_to @shipment.purchase if current_user&.superuser?
  end

  private

  def create_shipments(purchase, destination)
    purchase.storagefacilities.uniq.each do |storage|
      purchase.shipments << Shipment.new(
        location_name: destination.name,
        account_name: purchase.user.get_name,
        address: destination.address,
        shipping_provider: storage.shipping_provider,
        origin_address: storage.address,
        origin_name: storage.name,
        origin_account: 'Craig Perez (SemenHub)'
      )
    end
  end

  def shipment_update_params
    params.require(:shipment).permit(:tracking_number)
  end

end
