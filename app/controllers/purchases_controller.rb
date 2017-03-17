class PurchasesController < ApplicationController

  helper :authorize_net
  protect_from_forgery except: :recipt

  def perms
    return super unless ["show", "get_address", "recipt"].include?(params[:action])
    :purchase
  end

  def show
    @purchase = Purchase.find(params[:id])
    @purchase.build_shipment if @purchase.shipment.blank?
    @partial = @purchase.state if lookup_context.exists?(@purchase.state, _prefixes, true)
  end

  def index
    @purchases = Purchase.all
  end

  def get_address
    @purchase = Purchase.find(params[:id])
    @storage = StorageFacility.find_by_address_id(params[:shipment][:address_id])
    @purchase.shipment = Shipment.new(address: @storage.address, account_name: current_user.get_name )
    @purchase.invoiced!
    redirect_to @purchase
  end

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
      @purchase.paid!
      ReceiptMailer.send_receipt(current_user, @purchase).deliver_later
      redirect_to @purchase
    else
      flash[:alert] = 'There was a problem processing your card. Please check the entered values and try again.'
      redirect_to @purchase
    end
  end


end
