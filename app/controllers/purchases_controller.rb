class PurchasesController < ApplicationController

  helper :authorize_net
  before_action :set_purchase, only: [:show]
  before_action :set_purchase_sub, only: [:invoice, :paid, :shipped, :delivered, :administrative, :reset, :payment]

  def perms
    return :admin_purchase unless ["show", "get_address", "recipt", "index"].include?(params[:action])
    :purchase
  end

  def show
    redirect_to '/401' unless @purchase.user == current_user || current_user.can?(:admin_purchase)
    @partial = @purchase.state if lookup_context.exists?(@purchase.state, _prefixes, true)
  end

  def index
    @purchases = current_user.can?(:admin_purchase) ? Purchase.all : Purchase.where(user: current_user)
    @purchases = @purchases.order(id: :desc)
  end

  def invoice
    @purchase.invoiced!
    PurchaseMailer.invoice(@purchase).deliver_now

    redirect_to @purchase
  end

  def paid
    @purchase.paid!
    if Setting.get_setting(:send_purchase_emails).value != 'true'
      flash[:notice] = "Emails not sent"
    else
      @purchase.send_all_emails
    end

    redirect_to @purchase
  end

  def shipped
    @purchase.shipped!

    redirect_to @purchase
  end

  def delivered
    @purchase.delivered!

    redirect_to @purchase
  end

  def administrative
    @purchase.administrative!

    redirect_to @purchase
  end

  def reset
    @purchase.created!
    @purchase.shipments.destroy_all
    @purchase.line_items.destroy_all

    redirect_to @purchase
  end

  def payment
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

  private

  def set_purchase
    @purchase = Purchase.find(params[:id])
  end
  def set_purchase_sub
    @purchase = Purchase.find(params[:purchase_id])
  end

end
