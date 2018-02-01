class StorageFacility < ApplicationRecord
  enum shipping_provider: Shipment.shipping_providers

  belongs_to :address

  has_many :fees
  has_many :skus, foreign_key: 'storagefacility_id'


  validates :email, presence: true, email: true
  validates :phone_number, presence: true
  validates :website, presence: true
  validates :name, presence: true
  validates :shipping_provider, presence: true
  validates :straws_per_shipment, presence: true

  after_initialize :set_defaults

  def get_packages(semen_count, semen_per_container=straws_per_shipment)
    packages = []
    (semen_count/semen_per_container.to_f).ceil.times {
    packages << ActiveShipping::Package.new(18144,               #Weight (Grams)
                                [61,41],           # 93 cm long, 10 cm diameter
                                cylinder: true)   # cylinders have different volume calculations
    }
    packages
  end

  #TODO refactor to be simpler and easier to test
  def get_shipping_price(semen_count, destination, semen_per_container=straws_per_shipment) # How to test this???
    location = destination.get_shipping_location if destination.respond_to? :get_shipping_location
    location = destination.address.get_shipping_location if destination.respond_to? :address
    return unless location
    packages = get_packages(semen_count, semen_per_container)
    response = $active_shipping[shipping_provider].find_rates(address.get_shipping_location, location, packages)
    out_price = response.rates.select{|rate| rate.service_name =~ /ground/i }[0].total_price
    response = $active_shipping[shipping_provider].find_rates(location, address.get_shipping_location, packages)
    in_price = response.rates.select{|rate| rate.service_name =~ /ground/i }[0].total_price
    out_price *= (out_adjust.to_f / 100) unless out_adjust.nil?;
    in_price *= (in_adjust.to_f / 100) unless in_adjust.nil?;
    {out_price: out_price, in_price: in_price, total: out_price + in_price}
  end

  private

  def set_defaults
    self.admin_required = true if self.admin_required.nil?
  end
end
