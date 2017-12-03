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
      @purchase = FactoryBot.build(:purchase, :with_shipments)
    end
    it 'should has a User' do
      expect(@purchase.user).to be_a User
    end
    it 'should have purchase_transactions'
    it 'should have Transactions via purchase_transactions'
    it 'should have Skus thru Transactions'
    it 'should have Users as sellers thru Skus'
    it 'should have StorageFacilities thru Skus'
    it 'should have LineItem'
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
    context 'when all shipments are to the us' do
      it 'should call create_storage_facility_sh for each storage facility'
    end
    context 'when any shipment is not to the us' do
      it 'should not call create_storage_facility_sh'
    end
    it 'should call update_service_fee'
  end

  describe 'create_storage_facility_sh' do
    context 'when storage_facility.admin_required = false' do
      it 'should create a line item'
      it 'should create a line item with format "name: #{storage_facility.name}"'
      it 'should create a line item with value = all storage facility fees + return from get_shipping_price'
    end
    context 'when storage_facility.admin_required = true' do
      it 'should not create a line item'
    end
  end

  describe 'update_service_fee' do
    context 'when service fee does not exist' do
      it 'should add a line_item'
      it 'should create line item with 3% of total value'
    end
    context 'when service fee exists' do
      it 'should not add a line_item'
      it 'should update service fee line item to 3% of total value without previous service fee'
    end
  end

  describe 'Totals' do
    before do
      @purchase = FactoryBot.build(:purchase)
    end
    context 'total' do
      it 'should call transaction_total'
      it 'should call line_items_tatal'
      it 'should return sum of transaction_total and line_items_total'
    end
    context 'transaction_total' do
      it 'should work'
    end
    context 'fees_total' do
      it 'should work'
    end
    context 'line_items_total' do
      it 'should work'
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
