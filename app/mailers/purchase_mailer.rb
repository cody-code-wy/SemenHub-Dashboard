class PurchaseMailer < ApplicationMailer
  default from: 'default@semenhub.shop'
  layout 'mailer'

  def incomplete_invoice(purchase)
    @purchase = purchase
    mail(to: @purchase.user.email, subject: 'Your SemenHub Order Update')
  end

end
