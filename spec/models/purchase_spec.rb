require 'rails_helper'

RSpec.describe Purchase, type: :model do

  describe 'Factory' do
    it 'should have a valid factory' do
      expect(FactoryBot.build(:purchase)).to be_valid
    end

    it 'should have a valid factory with :paid' do
      expect(FactoryBot.build(:purchase, :paid)).to be_valid
    end

    it 'should have a valid fatroy :with_shipments' do
      expect(FactoryBot.build(:purchase, :with_shipments)).to be_valid
    end
  end

  describe 'Validations' do
    it 'should not be valid without user' do
      expect(FactoryBot.build(:purchase, user: nil)).to_not be_valid
    end
    it 'should not be valid without state' do
      expect(FactoryBot.build(:purchase, state: nil)).to_not be_valid
    end
    it 'shold be valid without authorization_code' do
      expect(FactoryBot.build(:purchase, authorization_code: nil)).to be_valid
    end
    it 'shold be valid without transaction_id' do #not a relation!
      expect(FactoryBot.build(:purchase, transaction_id: nil)).to be_valid
    end
  end

  describe 'Relations' do
    before do
      @purchase = FactoryBot.build(:purchase, :with_line_items, :with_shipments)
    end
    it 'should has a User' do
      expect(@purchase.user).to be_a User
    end
    it 'should have purchase_transactions'
    it 'should have Invetory Transactions thru purchase_transactions'
    it 'should have Skus thru Inventory Transactions'
    it 'should have Users as sellers thru Skus'
    it 'should have StorageFacilities thru Skus'
    it 'should have LineItems' do
      expect(@purchase.line_items.first).to be_a LineItem
    end
    it 'should have Shipments' do
      expect(@purchase.shipments.first).to be_a Shipment
    end
  end

  it 'state should be in the enum Purchase.states' do
    Purchase.states.each do |state, num|
      expect(FactoryBot.build(:purchase, state: state)).to be_valid
    end
  end

  describe 'Create_line_items' do
    before do
      @purchase = FactoryBot.build(:purchase, :with_shipments)
      allow(@purchase).to receive_messages(create_storage_facility_sh: nil, update_service_fee: nil)
    end
    context 'when all shipments are to the us' do
      it 'should call create_storage_facility_sh for each storage facility'
    end
    context 'when any shipment is not to the us' do
      before do
        @purchase.shipments.last.address.alpha_2 = 'ca'
      end
      it 'should not call create_storage_facility_sh' do
        expect(@purchase).to_not receive(:create_storage_facility_sh)
        @purchase.create_line_items
      end
    end
    it 'should call update_service_fee' do
      expect(@purchase).to receive(:update_service_fee)
      @purchase.create_line_items
    end
  end

  describe 'create_storage_facility_sh' do
    before do
      @purchase = FactoryBot.build(:purchase)
      @storage = FactoryBot.build(:storage_facility)
      allow(@storage).to receive(:get_shipping_price) {  {total: 500} }
      allow(@purchase).to receive_messages(get_storage_facility_fees: 5.0, get_storage_facility_shipping: 5.0)
    end
    context 'when storage_facility.admin_required = false' do
      it 'should create a line item' do
        expect{
          @purchase.create_storage_facility_sh(@storage)
        }.to change(LineItem,:count).and change(@purchase.line_items,:count)
      end
      it 'should call get_storage_facility_fees' do
        expect(@purchase).to receive(:get_storage_facility_fees)
        @purchase.create_storage_facility_sh(@storage)
      end
      it 'should call get_storage_facility_shipping' do
        expect(@purchase).to receive(:get_storage_facility_shipping)
        @purchase.create_storage_facility_sh(@storage)
      end
      it 'should create a line item with format "name: #{storage_facility.name}"' do
        @purchase.create_storage_facility_sh(@storage)
        expect(LineItem.last.name).to eq "#{@storage.name} S&H"
      end
      it 'should create a line item with value = get_storage_facility_fees + get_storage_facility_shipping' do
        @purchase.create_storage_facility_sh(@storage)
        expect(LineItem.last.value).to eq 10
      end
    end
    context 'when storage_facility.admin_required = true' do
      before do
        allow(@storage).to receive(:admin_required) { true }
      end
      it 'should not create a line item' do
        expect {
          @purchase.create_storage_facility_sh(@storage)
        }.to_not change(LineItem,:count)
      end
      it 'should not call get_storage_facility_fees' do
        expect(@purchase).to_not receive(:get_storage_facility_fees)
        @purchase.create_storage_facility_sh(@storage)
      end
      it 'should not call get_storage_facility_shipping' do
        expect(@purchase).to_not receive(:get_storage_facility_shipping)
        @purchase.create_storage_facility_sh(@storage)
      end
    end
  end

  describe 'get_storage_facility_fees' do
    before do
      @purchase = FactoryBot.build(:purchase)
      @storage = FactoryBot.build(:storage_facility, :with_fees)
      @storage.fees.each do |fee|
        allow(fee).to receive(:price) { 1 }
      end
    end
    it 'should return sum of storage facility\'s fee prices' do
      expect(@purchase.get_storage_facility_fees(@storage)).to eq 2
    end
    it 'should call Fee.Price on each fee' do
      @storage.fees.each do |fee|
        expect(fee).to receive(:price) { 1 }
      end
      @purchase.get_storage_facility_fees(@storage)
    end
  end

  describe 'get_shipment_item_count' do
    it 'should return number of straws shipping from storagefacility'
  end

  describe 'get_storage_facility_shipping' do
    before do
      @purchase = FactoryBot.create(:purchase, :with_shipments)
      address = @purchase.shipments.first.origin_address
      @storage = FactoryBot.build(:storage_facility, address: address)
      allow(@storage).to receive(:get_shipping_price) { {total: 100} }
      allow(@purchase).to receive(:get_shipment_item_count) { 10 }
    end
    it 'should call get_shipment_item_count' do
      expect(@purchase).to receive(:get_shipment_item_count) { 10 }
      @purchase.get_storage_facility_shipping(@storage)
    end
    it 'should call StorageFacility.get_shipping_price' do
      expect(@storage).to receive(:get_shipping_price) { {total: 10} }
      @purchase.get_storage_facility_shipping(@storage)
    end
    it 'should return the total returned by StorageFacility.get_shipping_price[:total] / 100' do
      expect(@purchase.get_storage_facility_shipping(@storage)).to eq 1.0
    end
  end

  describe 'update_service_fee' do
    before do
      @purchase = FactoryBot.build(:purchase)
    end
    context 'when service fee does not exist' do
      it 'should add a line_item' do
        expect {
          @purchase.update_service_fee
        }.to change {
          @purchase.line_items.length
        }.by 1
      end
      it 'should create line item with 3% of total value' do
        expect(@purchase).to receive(:total) { 100 }
        @purchase.update_service_fee
        expect(@purchase.line_items.last.value).to eq 3
      end
    end
    context 'when service fee exists' do
      before do
        @service_fee = FactoryBot.create(:line_item, name: 'SemenHub Service Fee', value: 3 , purchase: @purchase)
        @purchase.line_items << @service_fee
      end
      it 'should not add a line_item' do
        expect {
          @purchase.update_service_fee
        }.to_not change {
          @purchase.line_items.length
        }
      end
      it 'should update service fee line item to 3% of total value without previous service fee' do
        expect(@purchase).to receive(:total) { 203 }
        expect {
          @purchase.update_service_fee
        }.to change {
          @service_fee.reload
          @service_fee.value
        }.by 3
      end
    end
  end

  describe 'Totals' do
    before do
      @purchase = FactoryBot.build(:purchase, :with_line_items)
    end
    context 'total' do
      before do
        allow(@purchase).to receive_messages(transaction_total: 1, line_items_total: 1)
      end
      it 'should call transaction_total' do
        expect(@purchase).to receive(:transaction_total) { 1 }
        @purchase.total
      end
      it 'should call line_items_total' do
        expect(@purchase).to receive(:line_items_total) { 1 }
        @purchase.total
      end
      it 'should return sum of transaction_total and line_items_total' do
        expect(@purchase.total).to eq 2
      end
    end
    context 'transaction_total' do
      it 'should work'
    end
    context 'fees_total' do
      it 'should work'
    end
    context 'line_items_total' do
      describe 'No line items' do
        before do
          @purchase = FactoryBot.build(:purchase)
        end
        it 'should return 0' do
          expect(@purchase.line_items.length).to eq 0 #sanity check
          expect(@purchase.line_items_total).to eq 0
        end
      end
      describe 'line_items with value=nil' do
        it 'should not change value of return when exists line_item with value=nil' do
          expect {
            @purchase.line_items << FactoryBot.build(:line_item, value: nil)
          }.to_not change {
            @purchase.line_items_total
          }
        end
      end
      it 'should call value on each line items' do
        @purchase.line_items.each do |li|
          expect(li).to receive(:value).at_least(:once) { 1 }
        end
        @purchase.line_items_total
      end
      it 'should return sum of all line items' do
        @purchase.line_items.each do |li|
          expect(li).to receive(:value).at_least(:once) { 1 }
        end
        expect(@purchase.line_items_total).to eq @purchase.line_items.length # not count, purchase is not commited to db
      end
    end
  end

  describe 'Emails' do
    before do
      @purchase = FactoryBot.build(:purchase)
    end
    context 'send_all_emails' do
      before do
        allow(@purchase).to receive_messages(send_purchase_orders: nil, send_shipping_orders: nil, send_release_orders: nil)
        @mail = double()
        allow(@mail).to receive(:deliver_now)
        allow(PurchaseMailer).to receive_messages(invoice: @mail, receipt: @mail, purchase_order: @mail, shipping_order: @mail, release_order: @mail)
      end
      it 'should send receipt' do
        mail = double()
        expect(PurchaseMailer).to receive(:receipt).with(@purchase).and_return(mail)
        expect(mail).to receive(:deliver_now)
        @purchase.send_all_emails
      end
      it 'should call send_purchase_orders' do
        expect(@purchase).to receive(:send_purchase_orders)
        @purchase.send_all_emails
      end
      it 'should call send_shipping_orders' do
        expect(@purchase).to receive(:send_shipping_orders)
        @purchase.send_all_emails
      end
      it 'should call send_release_orders' do
        expect(@purchase).to receive(:send_release_orders)
        @purchase.send_all_emails
      end
    end
    context 'send_purchase_orders' do
      it 'should send a purchase order for each seller'
    end
    context 'send_shipping_orders' do
      it 'should send a shipping_order for each storage facility'
    end
    context 'send_release_orders' do
      it 'should send a release order for each seller'
    end
  end
end
