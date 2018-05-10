require 'rails_helper'

RSpec.feature "Purchases", type: :feature do
  before do
    visit '/login'
    within 'form' do
      fill_in('email', with: 'admin@test.com')
      fill_in('password', with: 'password')
      click_on('Login')
    end
  end
  feature 'Administrative Only Display' do
    before do
      @purchase = FactoryBot.create(:purchase, :with_inventory_transactions, user: User.find_by_email('user@test.com'))
      visit purchase_path(@purchase)
    end
    describe 'User is Administrator' do
      it 'should have seller table header' do
        within '.order-items-header' do
          expect(page).to have_text 'Seller'
        end
      end
      it 'should have seller names in sku rows' do
        within '.order-items-body' do
          @purchase.skus.each do |s|
            expect(page).to have_text s.seller.get_name
          end
        end
      end
      it 'shoud have administrative controls' do
        expect(page).to have_text 'Administrative Controls'
      end
    end
    describe 'User is not Administrator' do
      before do
        visit '/logout'
        visit '/login'
        within 'form' do
          fill_in('email', with: 'user@test.com')
          fill_in('password', with: 'password')
          click_on('Login')
        end
        visit purchase_path(@purchase)
      end
      it 'should not have seller table header' do
        within '.order-items-header' do
          expect(page).to_not have_text 'Seller'
        end
      end
      it 'should not have seller names in sku rows' do
        within '.order-items-body' do
          @purchase.skus.each do |s|
            expect(page).to_not have_text s.seller.get_name
          end
        end
      end
      it 'should not have administrative controls' do
        expect(page).to_not have_text 'Administrative Controls'
      end
    end
  end
  feature 'Administrative Controls' do
    before do
      @purchase = FactoryBot.create(:purchase, state: :administrative)
      visit purchase_path(@purchase)
    end
    describe 'Clear for payment' do
      it 'should send email' do
        expect(Purchase).to receive(:find).twice.with(@purchase.id.to_s) {@purchase} #twice once for update, once for show!
        @mail = double()
        expect(@mail).to receive(:deliver_now)
        expect(PurchaseMailer).to receive(:invoice).with(@purchase) {@mail}
        click_on('Clear for payment')
      end
      it 'should change purchase to invoiced status' do
        click_on('Clear for payment')
        expect(page).to have_content('Purchase State: invoiced')
        @purchase.reload
        expect(@purchase).to be_invoiced
      end
    end
    describe 'Mark Unpaid' do
      it 'should send email' do
        expect(Purchase).to receive(:find).twice.with(@purchase.id.to_s) {@purchase} #twice once for update, once for show!
        @mail = double()
        expect(@mail).to receive(:deliver_now)
        expect(PurchaseMailer).to receive(:invoice).with(@purchase) {@mail}
        click_on('Mark Unpaid')
      end
      it 'should change purchase to invoiced status' do
        click_on('Mark Unpaid')
        expect(page).to have_content('Purchase State: invoiced')
        @purchase.reload
        expect(@purchase).to be_invoiced
      end
    end
    describe 'Mark Paid' do
      it 'should set purchase to paid' do
        click_on('Mark Paid')
        expect(page).to have_content('Purchase State: paid')
        @purchase.reload
        expect(@purchase).to be_paid
      end
      context 'setting send_purchase_emails is true' do
        before do
          Setting.get_setting(:send_purchase_emails).update(value: 'true')
        end
        it 'should call send_all_emails on purchase' do
          expect(Purchase).to receive(:find).twice.with(@purchase.id.to_s) {@purchase}
          expect(@purchase).to receive(:send_all_emails)
          click_on('Mark Paid')
        end
      end
      context 'setting send_purchase_emails is not true' do
        before do
          Setting.get_setting(:send_purchase_emails).update(value: 'false')
        end
        it 'should not call send_all_emails on purchase' do
          expect(Purchase).to receive(:find).twice.with(@purchase.id.to_s) {@purchase}
          expect(@purchase).to_not receive(:send_all_emails)
          click_on('Mark Paid')
        end
        it 'should have notice on page' do
          click_on('Mark Paid')
          expect(page).to have_content('Emails not sent')
        end
      end
    end
    describe 'Mark Shipped' do
      it 'should mark purchase shipped' do
        click_on('Mark Shipped')
        expect(page).to have_content('Purchase State: shipped')
        @purchase.reload
        expect(@purchase).to be_shipped
      end
    end
    describe 'Mark Delivered' do
      it 'should mark purchase delivered' do
        click_on('Mark Delivered')
        expect(page).to have_content('Purchase State: delivered')
        @purchase.reload
        expect(@purchase).to be_delivered
      end
    end
    describe 'Mark Administrative' do
      it 'should mark purcahse administrative' do
        click_on('Mark Administrative')
        expect(page).to have_content('Purchase State: administrative')
        @purchase.reload
        expect(@purchase).to be_administrative
      end
    end
    describe 'Reset Order' do
      before do
        @purchase.shipments = FactoryBot.build_list(:shipment, 3)
        @purchase.line_items = FactoryBot.build_list(:line_item, 1, name: 'test line item')
        # @purchase.save()
        visit purchase_path(@purchase) # load changes
      end
      it 'should have shipments before' do
        expect(page).to have_css('.shipments')
        expect(page).to have_css('.shipment')
      end
      it 'should have line items after' do
        expect(page).to have_content('test line item')
      end
      it 'should not have shipments after' do
        click_on('Reset Order')
        expect(page).to have_css('.shipments') #still exists
        expect(page).to_not have_css('.shipment')
        @purchase.reload
        expect(@purchase.shipments).to be_empty
      end
      it 'should not have line items after' do
        click_on('Reset Order')
        expect(page).to_not have_content('test line item')
        @purchase.reload
        expect(@purchase.line_items).to be_empty
      end
      it 'should have state created after' do
        click_on('Reset Order')
        expect(page).to have_content('Purchase State: created')
        @purchase.reload
        expect(@purchase).to be_created
      end
    end
  end
  context 'created' do
    before do
      @purchase = FactoryBot.create(:purchase, :with_inventory_transactions, state: :created)
      visit purchase_path(@purchase)
      allow(@purchase).to receive(:get_storage_facility_shipping) {1.0}
      allow(Purchase).to receive(:find).and_call_original
      allow(Purchase).to receive(:find).with(@purchase.id.to_s) {@purchase}
    end
    describe 'shipping from storage facility with require admin set' do
      before do
        @purchase.storagefacilities.first.update(admin_required: true)
        choose('shipment_options_option_user')
      end
      it 'should mark as administrative' do
        click_on('Create Shipment')
        @purchase.reload
        expect(@purchase).to be_administrative
      end
    end
    describe 'shipping from non us facility' do
      before do
        @purchase.skus.first.storagefacility.address.update(alpha_2: 'ca')
        choose('shipment_options_option_user')
      end
      it 'should mark as administrative' do
        click_on('Create Shipment')
        @purchase.reload
        expect(@purchase).to be_administrative
      end
    end
    describe 'shipping to non us facility' do
      before do
        @purchase.user.mailing_address.update(alpha_2: 'ca')
        choose('shipment_options_option_user')
      end
      it 'should mark as administrative' do
        click_on('Create Shipment')
        @purchase.reload
        expect(@purchase).to be_administrative
      end
    end
    describe 'error calculating S&H' do
      it 'should mark as administrative' do
        expect(@purchase).to receive(:get_storage_facility_shipping).and_raise(StandardError)
        click_on('Create Shipment')
        @purchase.reload
        expect(@purchase).to be_administrative
      end
    end
    describe 'Send to Storage Facility' do
      before do
        FactoryBot.create_list(:storage_facility, 2)
        visit purchase_path(@purchase)
        choose('shipment_options_option_storage')
        select(StorageFacility.last.name)
      end
      it 'should create shipment to storage facility' do
        expect{
          click_on('Create Shipment')
        }.to change(Shipment,:count)
        expect(Shipment.last.address).to eq StorageFacility.last.address
      end
      it 'should change purchase to invoiced' do
        click_on('Create Shipment')
        @purchase.reload
        expect(@purchase).to be_invoiced
      end
      it 'should change purchase to administrative if mark as administrative checked' do
        check('shipment_options_admin')
        click_on('Create Shipment')
        @purchase.reload
        expect(@purchase).to be_administrative
      end
    end
    describe 'Send to personal address' do
      before do
        choose('shipment_options_option_user')
      end
      it 'should create shipment to user' do
        expect{
          click_on('Create Shipment')
        }.to change(Shipment,:count)
        expect(Shipment.last.address).to eq @purchase.user.mailing_address
      end
      it 'should change purchase to invoiced' do
        click_on('Create Shipment')
        @purchase.reload
        expect(@purchase).to be_invoiced
      end
      it 'should change purchase to administrative if mark as administrtive checked' do
        check('shipment_options_admin')
        click_on('Create Shipment')
        @purchase.reload
        expect(@purchase).to be_administrative
      end
    end
    describe 'Send to custom address' do
      before do
        choose('shipment_options_option_custom')
        addr = FactoryBot.build(:address)
        fill_in('shipment_location_name', with: 'Dest Name')
        fill_in('shipment_account_name', with: 'Acct Name')
        fill_in('shipment_phone_number', with: @purchase.user.phone_primary)
        fill_in('shipment_address_line1', with: addr.line1)
        fill_in('shipment_address_line2', with: addr.line2)
        fill_in('shipment_address_postal_code', with: addr.postal_code)
        fill_in('shipment_address_city', with: addr.city)
        fill_in('shipment_address_region', with: addr.region)
      end
      it 'should create shipment to new address' do
        expect{
          click_on('Create Shipment')
        }.to change(Shipment, :count).and change(Address, :count)
        expect(Shipment.last.address).to eq Address.last
      end
      it 'should change purchase to invoiced' do
        click_on('Create Shipment')
        @purchase.reload
        expect(@purchase).to be_invoiced
      end
      it 'should change purchase to administrative if mark as administrtive checked' do
        check('shipment_options_admin')
        click_on('Create Shipment')
        @purchase.reload
        expect(@purchase).to be_administrative
      end
      context 'invalid address' do
        before do
          fill_in('shipment_address_line1', with: '')
        end
        it 'should not create shipment' do
          expect{
            click_on('Create Shipment')
          }.to_not change(Shipment, :count)
        end
        it 'should not create address' do
          expect{
            click_on('Create Shipment')
          }.to_not change(Shipment, :count)
        end
        it 'should notify user' do
          click_on('Create Shipment')
          expect(page).to have_content('The address field was not filled out correctly. Please try again.')
        end
      end
    end
  end
  context 'invoiced' do
    let(:valid_card) { ['5424000000000015','2223000010309703','2223000010309711','4111111111111111'].sample } #prevent duplicat trans on same card
    before do
      @purchase = FactoryBot.create(:purchase, :for_test_transaction)
      visit purchase_path(@purchase)
      allow(Purchase).to receive(:find).and_call_original
      allow(Purchase).to receive(:find).with(@purchase.id.to_s) {@purchase}
    end
    describe 'valid card' do
      before do
        fill_in('card_num', with: valid_card)
        fill_in('exp_date', with: 1.year.from_now.strftime('%m%y'))
        fill_in('ccv', with: '123')
      end
      it 'should update purchase' do
        expect{
          click_on('Purchase')
        }.to change{
          @purchase.reload
          @purchase.authorization_code
        }.and change{
          @purchase.reload
          @purchase.transaction_id
        }
      end
      it 'should change purchase state to paid' do
        click_on('Purchase')
        @purchase.reload
        expect(@purchase).to be_paid
      end
      context 'setting send_purchase_emails true' do
        before do
          Setting.get_setting(:send_purchase_emails).update(value: 'true')
        end
        it 'should call send_all_emails on purchase' do
          expect(@purchase).to receive(:send_all_emails)
          click_on('Purchase')
        end
      end
      context 'setting send_purchase_emails not true' do
        before do
          Setting.get_setting(:send_purchase_emails).update(value: 'false')
        end
        it 'should not call send_all_emails' do
          expect(@purchase).to_not receive(:send_all_emails)
          click_on('Purchase')
        end
        it 'should notify the user' do
          click_on('Purchase')
          expect(page).to have_content('Emails were not sent')
        end
      end
    end
    describe 'invalid card' do
      before do
        fill_in('card_num', with: '1029102910291029')
        fill_in('exp_date', with: 1.year.from_now.strftime('%m%y'))
        fill_in('ccv', with: '901')
      end
      it 'should not update purchase authorization code' do
        expect{
          click_on('Purchase')
        }.to_not change{
          @purchase.reload
          @purchase.authorization_code
        }
      end
      it 'should not update purchase transaction id' do
        expect{
          click_on('Purchase')
        }.to_not change{
          @purchase.reload
          @purchase.transaction_id
        }
      end
      it 'should not change purchase state' do
        click_on('Purchase')
        @purchase.reload
        expect(@purchase).to be_invoiced
      end
      it 'should notify user' do
        click_on('Purchase')
        expect(page).to have_content('The transaction was unsuccessful')
      end
    end
  end
end
