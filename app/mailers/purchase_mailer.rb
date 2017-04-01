class PurchaseMailer < ApplicationMailer
  default from: 'default@semenhub.shop'
  layout 'mailer'


  def administrative_notice(purchase)
    @purchase = purchase
    mail(to: 'semenhub@gmail.com', subject: "Purchases Administrative Notice #{@purchase.user.get_name}")
  end

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
