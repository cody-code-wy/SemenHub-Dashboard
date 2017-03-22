class Purchase < ApplicationRecord
  belongs_to :user

  has_many :purchase_transactions
  has_many :inventory_transactions, through: :purchase_transactions
  has_many :skus, through: :inventory_transactions
  has_many :storagefacilities, through: :skus
  has_many :line_items

  has_one :shipment

  enum state: ["problem", "created", "invoiced", "paid", "preparing for shipment", "shipped", "delivered", "canceled", "refunded"]

  #shipping info
  shipping = {diameter: 41, height: 61, weight: 18144, straws_per: 10}

  def create_line_items
    storagefacilities.uniq.each do |storage|
      storage.fees.each do |fee|
        line_items << LineItem.new(name: "#{storage.name} #{fee.fee_type} fee", value: fee.price )
      end
    end
    line_items
  end

  def total
    transaction_total + fees_total + shipping_fees
  end

  def transaction_total
    inventory_transactions.reduce(0) do |sum,trans|
      sum + -(trans.quantity * trans.sku.price_per_unit)
    end
  end

  def fees_total
    storagefacilities.uniq.reduce(0) do |sum,storage|
      sum + storage.fees.reduce(0){ |sum,fee| sum + fee.price }
    end
  end

  def shipping_fees
    return 0 unless shipment and shipment.id
    @sf = StorageFacility.find_by_address_id(shipment.address_id)
    storagefacilities.uniq.reduce(0) do |sum,storage|
      return sum if storage.address == shipment.address
      quantity = -inventory_transactions.where(sku: Sku.where(storagefacility: storage)).sum(:quantity)
      puts "processing #{quantity} items from #{storage.name}"
      sum + storage.get_shipping_price(quantity, shipment)
    end.to_f / 100
  end
  
end
