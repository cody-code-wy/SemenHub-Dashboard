class ReceiptMailer < ApplicationMailer
  def send_receipt(user, purchase)
    @user = user
    @purchase = purchase
    mail(from: 'purchases@semenhub.shop', to: user.email, subject: "Receipt for Purchase #{purchase.id}")
  end
end
