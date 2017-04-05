class PurchaseMailer < ApplicationMailer
  default from: 'semenhub@gmail.com'
  layout 'mailer'


  def administrative_notice(purchase)
    @purchase = purchase
    mail(to: 'semenhub@gmail.com', subject: "Purchase #{@purchase.id} Administrative Notice #{@purchase.user.get_name}")
  end

  def incomplete_invoice(purchase)
    @purchase = purchase
    mail(to: @purchase.user.email, subject: "Your SemenHub Order Update (purchase #{@purchase.id})")
  end

  def invoice(purchase)
    @purchase = purchase
    mail(to: @purchase.user.email, subject: "Your SemenHub Invoice (purchase #{@purchase.id})")
  end

  def receipt(purchase)
    @purchase = purchase
    mail(to: @purchase.user.email, subject: "Your SemenHub Receipt (purchase #{@purchase.id})")
  end

  def purchase_order(purchase, seller)
    @purchase = purchase
    @seller = seller
    @order_items = @purchase.inventory_transactions.where(sku: @seller.skus)
    mail(to: @seller.email, subject: "New SemenHub Purchase Order (purchase #{@purchase.id})")
  end

  def shipping_order(purchase, storagefacility)
    @purchase = purchase
    @storagefacility = storagefacility
    @order_items = @purchase.inventory_transactions.where(sku: @storagefacility.skus)
    mail(to: @storagefacility.email, subject: "New SemenHub Shipping Order (purchase #{@purchase.id})")
  end

end
