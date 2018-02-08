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
        @purchase.shipped!
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

  def recipt
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
      redirect_to @purchase
    else
      flash[:alert] = response.messages.messages.first.text
      puts "AUTHORIZENET:#{ response.messages.messages.first.code }:#{response.transactionResponse&.errors&.errors&.first&.errorCode}"
      redirect_to @purchase
    end
  end

end
