class PurchasesController < ApplicationController

  helper :authorize_net
  protect_from_forgery except: :recipt

  def perms
    return :admin_purchase unless ["show", "get_address", "recipt", "index"].include?(params[:action])
    :purchase
  end

  def show
    @purchase = Purchase.find(params[:id])
    redirect_to '/401' unless @purchase.user == current_user || current_user.can?(:admin_purchase)
    # @purchase.build_shipment if @purchase.shipment.blank?
    @partial = @purchase.state if lookup_context.exists?(@purchase.state, _prefixes, true)
  end

  def index
    @purchases = current_user.can?(:admin_purchase) ? Purchase.all : Purchase.where(user: current_user)
    @purchases = @purchases.order(id: :desc)
  end

  def update
    @purchase = Purchase.find(params[:id])
    case params[:purchase][:state]
      when "invoiced"
        @purchase.invoiced!
        PurchaseMailer.invoice(@purchase).deliver_now
      when "paid"
        @purchase.paid!
        if Setting.get_setting(:send_purchase_emails).value != 'true'
          flash[:notice] = "Emails not sent"
        else
          @purchase.send_all_emails
        end
      when "shipped"
        @puchase.shipped!
      when "delivered"
        @purchase.delivered!
      when "created"
        @purchase.created!
        @purchase.shipments.destroy_all
        @purchase.line_items.destroy_all
      else
        flash[:alert] = "There was an error with your administrative command"
    end
    redirect_to @purchase
  end

  # def get_address
  #   @purchase = Purchase.find(params[:id])
  #   @storage = StorageFacility.find_by_address_id(params[:shipment][:address_id])
  #   @purchase.shipment = Shipment.new(address: @storage.address, account_name: current_user.get_name )
  #   @purchase.administrative!
  #   flash[:alert] = "Your order requires administrative oversight and cannot be processed yet, no action is required on your part. \nYou will recieve an email when you can complete, and pay, for your order. We appologise for any inconvinience."
  #   redirect_to @purchase
  #end

  def recipt
    # byebug
    @purchase = Purchase.find(params[:id])
    transaction = AuthorizeNet::API::Transaction.new($authorizenet[:login], $authorizenet[:key], gateway: $authorizenet[:gateway])

    request = AuthorizeNet::API::CreateTransactionRequest.new()
    request.transactionRequest = AuthorizeNet::API::TransactionRequestType.new()
    request.transactionRequest.amount = @purchase.total
    request.transactionRequest.payment = AuthorizeNet::API::PaymentType.new
    request.transactionRequest.payment.creditCard = AuthorizeNet::API::CreditCardType.new(params[:card_num], params[:exp_date], params[:ccv])
    request.transactionRequest.transactionType = AuthorizeNet::API::TransactionTypeEnum::AuthCaptureTransaction

    response = transaction.create_transaction(request)

    if response.messages.resultCode == AuthorizeNet::API::MessageTypeEnum::Ok
      puts "Successful charge (auth + capture) (authorization code: #{response.transactionResponse.authCode}) (transaction ID: #{response.transactionResponse.transId})"
      @purchase.update(authorization_code: response.transactionResponse.authCode, transaction_id: response.transactionResponse.transId)
      @purchase.paid!
      if Setting.get_setting(:send_purchase_emails).value != 'true'
        flash[:alert] = 'Emails were not sent'
      else
        @purchase.send_all_emails
      end
      # send_all
      redirect_to @purchase
    else
      flash[:alert] = 'There was a problem processing your card. Please check the entered values and try again.'
      puts response.messages
      redirect_to @purchase
    end
  end

  # private

  # def send_all
  #   PurchaseMailer.receipt(@purchase).deliver_now
  #   send_purchase_orders
  #   send_shipping_orders
  #   send_release_orders
  # end

  # def send_purchase_orders
  #   @purchase.sellers.uniq.each do |seller|
  #     PurchaseMailer.purchase_order(@purchase, seller).deliver_now
  #   end
  # end

  # def send_shipping_orders
  #   @purchase.storagefacilities.uniq.each do |storage|
  #     PurchaseMailer.shipping_order(@purchase, storage).deliver_now
  #   end
  # end

  # def send_release_orders
  #   @purchase.sellers.uniq.each do |seller|
  #     @purchase.skus.where(seller: seller).pluck(:storagefacility_id).uniq.map{|id| StorageFacility.find(id)}.each do |facility|
  #       PurchaseMailer.release_order(@purchase, seller, facility).deliver_now
  #     end
  #   end
  # end


end
