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

end
