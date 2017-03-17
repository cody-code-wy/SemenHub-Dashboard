class StorageFacility < ApplicationRecord
  belongs_to :address
  has_many :fees

  enum shipping_provider: {
    'UPS': 0,
    'FedEx': 1
  }

  validates_presence_of :phone_number, :website, :name, :shipping_provider, :straws_per_shipment
  validates :email, presence: true, email: true

  def get_packages(semen_count, semen_per_container=straws_per_shipment)
    packages = []
    (semen_count/semen_per_container.to_f).ceil.times {
    packages << ActiveShipping::Package.new(18144,               #Weight (Grams)
                                [61,41],           # 93 cm long, 10 cm diameter
                                cylinder: true)   # cylinders have different volume calculations
    }
    packages
  end

  def get_shipping_price(semen_count, destination, semen_per_container=traws_per_shipment)
    location = destination.get_shipping_location if destination.respond_to? :get_shipping_location
    location = destination.address.get_shipping_location if destination.respond_to? :address
    return unless location
    packages = get_packages(semen_count, semen_per_container)
    response = $active_shipping[shipping_provider].find_rates(address.get_shipping_location, location, packages)
    response.rates.select{|rate| rate.service_name =~ /ground/i }[0].total_price
  end
end
