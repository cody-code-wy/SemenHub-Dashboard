# Preview all emails at http://localhost:3000/rails/mailers/purchase_mailer
class PurchaseMailerPreview < ActionMailer::Preview

  def incomplete_invoice
    PurchaseMailer.incomplete_invoice(Purchase.last)
  end

  def invoice
    PurchaseMailer.invoice(Purchase.last)
  end

end
