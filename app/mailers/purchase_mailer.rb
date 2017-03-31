class PurchaseMailer < ApplicationMailer
  default from: 'default@semenhub.shop'
  layout 'mailer'

  def incomplete_invoice(purchase)
    @purchase = purchase
    mail(to: @purchase.user.email, subject: 'Your SemenHub Order Update')
  end

  def invoice(purchase)
    @purchase = purchase
    mail(to: @purchase.user.email, subject: 'Your SemenHub Invoice')
  end

  def receipt(purchase)
    @purchase = purchase
    mail(to: @purchase.user.email, subject: 'Your SemenHub Receipt')
  end
end
