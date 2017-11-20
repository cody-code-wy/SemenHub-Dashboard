require 'rails_helper'

RSpec.describe StorageFacility, type: :model do

  it 'should have a valid factory' do
    expect(FactoryBot.build(:storage_facility)).to be_valid
  end

  describe 'Validations' do
    it 'should not be valid without phone_number' do
      expect(FactoryBot.build(:storage_facility, phone_number: nil)).to_not be_valid
    end
    it 'should not be valid without website' do
      expect(FactoryBot.build(:storage_facility, website: nil)).to_not be_valid
    end
    it 'should not be valid without address' do
      expect(FactoryBot.build(:storage_facility, address: nil)).to_not be_valid
    end
    it 'should not be valid without name' do
      expect(FactoryBot.build(:storage_facility, name: nil)).to_not be_valid
    end
    it 'should not be valid without email' do
      expect(FactoryBot.build(:storage_facility, email: nil)).to_not be_valid
    end
    it 'should not be valid without shipping_provider' do
      expect(FactoryBot.build(:storage_facility, shipping_provider: nil)).to_not be_valid
    end
    it 'should not be valid without straws_per_shipment' do
      expect(FactoryBot.build(:storage_facility, straws_per_shipment: nil)).to_not be_valid
    end
    it 'should be valid without admin_required' do
      expect(FactoryBot.build(:storage_facility, admin_required: nil)).to be_valid
    end
    it 'should be valid with out_adjust' do
      expect(FactoryBot.build(:storage_facility, out_adjust: nil)).to be_valid
    end
    it 'should be valid with in_adjust' do
      expect(FactoryBot.build(:storage_facility, in_adjust: nil)).to be_valid
    end
    it 'should not be valid with malformed email' do
      expect(FactoryBot.build(:storage_facility, email: 'not an email')).to_not be_valid
    end
  end

  it 'should have admin_required true by default' do
    expect(FactoryBot.build(:storage_facility, :without_admin_required))
  end
  it 'shipping_provider should be one of Shipment.shipping_providers' do
    Shipment.shipping_providers.each do |provider, num|
      @storageFacility = FactoryBot.build(:storage_facility, shipping_provider: provider)
      expect(@storageFacility).to be_valid
    end
  end

  describe 'Relations' do
    it 'should have an Address' do
      expect(FactoryBot.build(:storage_facility).address).to be_a Address
    end
    it 'should have fees of type Fee'
    it 'should have skus of type SKU'
  end

  describe 'Get Packages' do
    before do
      @storageFacility = FactoryBot.build(:storage_facility)
    end
    it 'should create array of packages of type ActiveShipping::Package' do
      expect(@storageFacility.get_packages(0)).to be_a Array
    end
    it 'should create one package when under straws_per_shipment' do
      expect(@storageFacility.get_packages(@storageFacility.straws_per_shipment-1).length).to eq 1
    end
    it 'should cerate one package when under semen_per_container' do
      expect(@storageFacility.get_packages(1,2).length).to eq 1
    end
    it 'should create one package when at straws_per_shipment' do
      expect(@storageFacility.get_packages(@storageFacility.straws_per_shipment).length).to eq 1
    end
    it 'should create one package when at semen_per_container' do
      expect(@storageFacility.get_packages(2,2).length).to eq 1
    end
    it 'should create two packages when over straws_per_shipmet' do
      expect(@storageFacility.get_packages(@storageFacility.straws_per_shipment+1).length).to eq 2
    end
    it 'should create two packages when over semen_per_container' do
      expect(@storageFacility.get_packages(3,2).length).to eq 2
    end
    it 'should create N packages when at N*straws_per_shipment' do
      (1..20).each do |n|
        expect(@storageFacility.get_packages(@storageFacility.straws_per_shipment*n).length).to eq n
      end
    end
    it 'should create N packages when at N*semen_per_container' do
      (1..20).each do |n|
        expect(@storageFacility.get_packages(n,1).length).to eq n
      end
    end
  end

  describe 'Get Shipping Price' do
    it 'should return correct prices'
  end

end
