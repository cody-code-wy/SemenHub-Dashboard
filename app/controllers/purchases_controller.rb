class PurchasesController < ApplicationController

  helper :authorize_net
  protect_from_forgery except: :recipt

  def secure
    not (["recipt"].include?(params[:action]))
  end
  def perms
    return super unless ["show"].include?(params[:action])
    :purchase
  end

  def show
    @purchase = Purchase.find(params[:id])
    @purchase.build_shipment if @purchase.shipment.blank?
    @partial = @purchase.state if lookup_context.exists?(@purchase.state, _prefixes, true)
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
      redirect_to @purchase
    else
      render text: "ERROR: #{response.messages.messages[0].text}"
    end
  end


end
