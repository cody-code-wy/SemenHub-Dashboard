require 'rails_helper'

RSpec.describe "Shipments", type: :request do
  before do
    @purchase = FactoryBot.create(:purchase, :with_inventory_transactions, state: :created)
    @shipment = FactoryBot.create(:shipment, :from_storage_facility, purchase: @purchase)
    @sf = FactoryBot.create(:storage_facility)
    @addr_atts = FactoryBot.attributes_for(:address)
    allow(Purchase).to receive(:find).and_call_original
    allow(Purchase).to receive(:find).with(@purchase.id.to_s) { @purchase }
    allow(@purchase).to receive(:create_line_items) #dont try to calculate shipping
  end
  let(:create_to_sf_params) { {shipment: {options: {option: 'storage'}, address_id: @sf.address_id} } }
  let(:create_to_user_params) { {shipment: {options: {option: 'user'}}} }
  let(:create_to_custom_params) { {shipment: {options: {option: 'custom'}, location_name: 'location', account_name: 'account', address: @addr_atts} } }
  let(:update_params) { {shipment: {tracking_number: 'tracking#123'} } }
  context 'logged out' do
    describe 'create' do
      before do
      end
      it 'should redirect to /login' do
        post purchase_shipments_path(@purchase), params: create_to_user_params
        expect(response).to redirect_to '/login'
      end
      it 'should not create shipments' do
        expect{
          post purchase_shipments_path(@purchase), params: create_to_user_params
        }.to_not change(Shipment, :count)
      end
    end
    describe 'show' do
      it 'should be success' do
        get purchase_shipment_path(@purchase, @shipment)
        expect(response).to be_success
      end
    end
    describe 'update' do
      it 'should change the shipments tracking number' do
        expect{
          put purchase_shipment_path(@purchase, @shipment), params: update_params
        }.to change{
          @shipment.reload
          @shipment.tracking_number
        }
        expect(@shipment.tracking_number).to eq 'tracking#123'
      end
      it 'should redirect to shipment' do
        put purchase_shipment_path(@purchase, @shipment), params: update_params
        expect(response).to redirect_to purchase_shipment_path(@purchase, @shipment)
      end
    end
  end
  context 'logged in' do
    before do
      post '/login', params: {email: 'test@test.com', password: 'password'}
    end
    describe 'create' do
      context 'shipping to storage facility' do
        let(:params) { create_to_sf_params }
        it 'should create shipments' do
          expect{
            post purchase_shipments_path(@purchase), params: params
          }.to change(Shipment, :count)
        end
        it 'should redirect to purchase' do
          post purchase_shipments_path(@purchase), params: params
          expect(response).to redirect_to purchase_path(@purchase)
        end
        it 'should mark purchase as invoiced' do
          post purchase_shipments_path(@purchase), params: params
          @purchase.reload
          expect(@purchase).to be_invoiced
        end
        describe 'source storage facility with admin_required set' do
          before do
            @purchase.storagefacilities.first.update(admin_required: true)
          end
          it 'should mark purchase as administrative' do
            post purchase_shipments_path(@purchase), params: params
            expect(response).to redirect_to purchase_path(@purchase)
          end
        end
        describe 'shipping to non us country' do
          before do
            @sf.address.update(alpha_2: 'ca')
          end
          it 'should mark purchase as administrative' do
            post purchase_shipments_path(@purchase), params: params
            expect(response).to redirect_to purchase_path(@purchase)
          end
        end
        describe 'shipping from non us country' do
          before do
            @purchase.storagefacilities.first.address.update(alpha_2: 'ca')
          end
          it 'should mark purchase as administrative' do
            post purchase_shipments_path(@purchase), params: params
            expect(response).to redirect_to purchase_path(@purchase)
          end
        end
        describe 'purchase create_line_items fails (trows error)' do
          before do
            expect(@purchase).to receive(:create_line_items).and_raise(StandardError)
          end
          it 'should mark purchase as administrative' do
            post purchase_shipments_path(@purchase), params: params
            expect(response).to redirect_to purchase_path(@purchase)
          end
        end
      end
      context 'shipping to user' do
        let(:params) { create_to_user_params }
        it 'should create shipments' do
          expect{
            post purchase_shipments_path(@purchase), params: params
          }.to change(Shipment, :count)
        end
        it 'should redirect to purchase' do
          post purchase_shipments_path(@purchase), params: params
          expect(response). to redirect_to purchase_path(@purchase)
        end
        it 'should mark purchase as invoiced' do
          post purchase_shipments_path(@purchase), params: params
          @purchase.reload
          expect(@purchase).to be_invoiced
        end
      end
      context' shipping to custom address' do
        let(:params) { create_to_custom_params }
        it 'should create shipments' do
          expect{
            post purchase_shipments_path(@purchase), params: params
          }.to change(Shipment, :count)
        end
        it 'should create address' do
          expect{
            post purchase_shipments_path(@purchase), params: params
          }.to change(Address, :count)
        end
        it 'should redirect to purchase' do
          post purchase_shipments_path(@purchase), params: params
          expect(response).to redirect_to purchase_path(@purchase)
        end
        it 'should mark purchase as invoiced' do
          post purchase_shipments_path(@purchase), params: params
          @purchase.reload
          expect(@purchase).to be_invoiced
        end
        describe 'invaild address' do
          before do
            @addr_atts[:line1] = nil
          end
          it 'should not create shipments' do
            expect{
              post purchase_shipments_path(@purchase), params: params
            }.to_not change(Shipment, :count)
          end
          it 'should not create address' do
            expect{
              post purchase_shipments_path(@purchase), params: params
            }.to_not change(Address, :count)
          end
          it 'should redirect to purchase' do
            post purchase_shipments_path(@purchase), params: params
            expect(response).to redirect_to purchase_path(@purchase)
          end
          it 'should not mark purchase as invoiced' do
            post purchase_shipments_path(@purchase), params: params
            @purchase.reload
            expect(@purchase).to_not be_invoiced
            expect(@purchase).to be_created
          end
          it 'should net flash[:alert]' do
            post purchase_shipments_path(@purchase), params: params
            expect(flash[:alert]).to_not be_empty
          end
        end
      end
    end
    describe 'show' do
      it 'should be success' do
        get purchase_shipment_path(@purchase, @shipment)
        expect(response).to be_success
      end
    end
    describe 'update' do
      it 'should add tracking number to shipment' do
        expect{
          put purchase_shipment_path(@purchase, @shipment), params: update_params
        }.to change{
          @shipment.reload
          @shipment.tracking_number
        }
        expect(@shipment.tracking_number).to eq 'tracking#123'
      end
      it 'should redirect to purchase' do
        put purchase_shipment_path(@purchase, @shipment), params: update_params
        expect(response).to redirect_to purchase_path(@purchase)
      end
    end
  end
end
