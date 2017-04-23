# Preview all emails at http://localhost:3000/rails/mailers/purchase_mailer
class PurchaseMailerPreview < ActionMailer::Preview

  def administrative_notice
    mail = PurchaseMailer.administrative_notice(Purchase.last)
    Premailer::Rails::Hook.perform(mail)
  end

  def incomplete_invoice
    mail = PurchaseMailer.incomplete_invoice(Purchase.last)
    Premailer::Rails::Hook.perform(mail)
  end

  def invoice
    mail = PurchaseMailer.invoice(Purchase.last)
    Premailer::Rails::Hook.perform(mail)
  end

  def receipt
    mail = PurchaseMailer.receipt(Purchase.last)
    Premailer::Rails::Hook.perform(mail)
  end

  def purchase_order
    mail = PurchaseMailer.purchase_order(Purchase.last, Purchase.last.sellers.first)
    Premailer::Rails::Hook.perform(mail)
  end

  def shipping_order
    mail = PurchaseMailer.shipping_order(
      Purchase.last,
      Purchase.last.shipments.where(origin_address: Purchase.last.storagefacilities.first.address).take,
      Purchase.last.storagefacilities.first
    )
    Premailer::Rails::Hook.perform(mail)
  end

  def release_order
    @purchase = Purchase.last
    @seller = @purchase.sellers.first
    @storagefacility = @purchase.skus.where(seller: @seller).first.storagefacility
    mail = PurchaseMailer.release_order(@purchase, @seller, @storagefacility)
    Premailer::Rails::Hook.perform(mail)
  end

end
