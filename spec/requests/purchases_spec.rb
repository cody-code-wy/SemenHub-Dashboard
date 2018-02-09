require 'rails_helper'

RSpec.describe "Purchases", type: :request do
  context 'logged out' do
    before do
      @purchase = FactoryBot.create(:purchase)
    end
    describe 'index' do
      it 'should redirect to /login' do
        get purchases_path
        expect(response).to redirect_to '/login'
      end
    end
    describe 'show' do
      it 'should redirect to /login' do
        get purchase_path(@purchase)
        expect(response).to redirect_to '/login'
      end
    end
    describe 'invoice' do
      it 'should redirect to /login' do
        post purchase_invoice_path(@purchase)
        expect(response).to redirect_to '/login'
      end
    end
    describe 'paid' do
      it 'should redirect to /login' do
        post purchase_paid_path(@purchase)
        expect(response).to redirect_to '/login'
      end
    end
    describe 'shipped' do
      it 'should redirect to /login' do
        post purchase_shipped_path(@purchase)
        expect(response).to redirect_to '/login'
      end
    end
    describe 'delivered' do
      it 'should redirect to /login' do
        post purchase_delivered_path(@purchase)
        expect(response).to redirect_to '/login'
      end
    end
    describe 'reset' do
      it 'should redirect to /login' do
        post purchase_reset_path(@purchase)
        expect(response).to redirect_to '/login'
      end
    end
    describe 'payment' do
      it 'should redirect to /login' do
        post purchase_path(@purchase)+'/payment'
        expect(response).to redirect_to '/login'
      end
    end
  end
  context 'logged in' do
    before do
      @purchase = FactoryBot.create(:purchase)
      post '/login', params: {email: 'test@test.com', password: 'password'}
    end
    describe 'index' do
      it 'should be success' do
        get purchases_path
        expect(response).to be_success
      end
    end
    describe 'show' do
      it 'should be success' do
        get purchase_path(@purchase)
        expect(response).to be_success
      end
    end
    describe 'invoice' do
      before do
        @purchase = FactoryBot.create(:purchase, state: :problem)
      end
      it 'should redirect to purchase' do
        post purchase_invoice_path(@purchase)
        expect(response).to redirect_to purchase_path(@purchase)
      end
      it 'should change purchase to invoiced' do
        post purchase_invoice_path(@purchase)
        @purchase.reload
        expect(@purchase).to be_invoiced
      end
      it 'should sent invoice email' do
        @mail = double()
        expect(@mail).to receive(:deliver_now)
        expect(PurchaseMailer).to receive(:invoice) { @mail }
        post purchase_invoice_path(@purchase)
      end
    end
    describe 'paid' do
      before do
        @purchase = FactoryBot.create(:purchase, state: :problem)
        allow(Purchase).to receive(:find).and_call_original
        allow(Purchase).to receive(:find).with(@purchase.id.to_s) { @purchase }
      end
      it 'should redirect to purchase' do
        post purchase_paid_path(@purchase)
        expect(response).to redirect_to purchase_path(@purchase)
      end
      it 'should change purchase to paid' do
        post purchase_paid_path(@purchase)
        @purchase.reload
        expect(@purchase).to be_paid
      end
      context 'setting send_purchase_emails true' do
        before do
          Setting.get_setting(:send_purchase_emails).update(value: 'true')
        end
        it 'should call send_all_emails' do
          expect(@purchase).to receive(:send_all_emails)
          post purchase_paid_path(@purchase)
        end
      end
      context 'setting send_purchase_emails not true' do
        before do
          Setting.get_setting(:send_purchase_emails).update(value: 'false')
        end
        it 'should not call send_all_emails' do
          expect(@purchase).to_not receive(:send_all_emails)
          post purchase_paid_path(@purchase)
        end
        it 'should set flash[:notice]' do
          post purchase_paid_path(@purchase)
          expect(flash[:notice]).to_not be_empty
        end
      end
    end
    describe 'shipped' do
      before do
        @purchase = FactoryBot.create(:purchase, state: :problem)
      end
      it 'should redirect to purchase' do
        post purchase_shipped_path(@purchase)
        expect(response).to redirect_to purchase_path(@purchase)
      end
      it 'should change purchase to shipped' do
        post purchase_shipped_path(@purchase)
        @purchase.reload
        expect(@purchase).to be_shipped
      end
    end
    describe 'delivered' do
      before do
        @purchase = FactoryBot.create(:purchase, state: :problem)
      end
      it 'should redirect to purchase' do
        post purchase_delivered_path(@purchase)
        expect(response).to redirect_to purchase_path(@purchase)
      end
      it 'should change purchase to delivered' do
        post purchase_delivered_path(@purchase)
        @purchase.reload
        expect(@purchase).to be_delivered
      end
    end
    describe 'reset' do
      before do
        @purchase = FactoryBot.create(:purchase, :with_shipments, :with_line_items, state: :invoiced)
      end
      it 'should redirect to purchase' do
        post purchase_reset_path(@purchase)
        expect(response).to redirect_to purchase_path(@purchase)
      end
      it 'should change purchase to created' do
        post purchase_reset_path(@purchase)
        @purchase.reload
        expect(@purchase).to be_created
      end
      it 'should destroy all shipments on purchase' do
        expect{
          post purchase_reset_path(@purchase)
        }.to change(Shipment, :count).and change{
          @purchase.reload
          @purchase.shipments.count
        }
        expect(@purchase.shipments.count).to eq 0
      end
      it 'should destroy all line items on purchase' do
        expect{
          post purchase_reset_path(@purchase)
        }.to change(LineItem, :count).and change{
          @purchase.reload
          @purchase.line_items.count
        }
        expect(@purchase.line_items.count).to eq 0
      end
    end
    describe 'payment' do
      before do
        @purchase = FactoryBot.create(:purchase, :for_test_transaction)
      end
      context 'valid card' do
        let(:valid_card) { ['5424000000000015','2223000010309703','2223000010309711','4111111111111111'].sample } #prevent duplicat trans on same card
        let(:params) { {card_num: valid_card, exp_date: 1.year.from_now.strftime('%m%y'),ccv: '123'} }
        it 'should redirect to purchase' do
          post purchase_payment_path(@purchase), params: params
          expect(response).to redirect_to purchase_path(@purchase)
        end
        it 'should change purchase to paid' do
          post purchase_payment_path(@purchase), params: params
          @purchase.reload
          expect(@purchase).to be_paid
        end
        it 'should change purchase authorization_code and transaction_id' do
          expect{
            post purchase_payment_path(@purchase), params: params
          }.to change{
            @purchase.reload
            @purchase.authorization_code
          }.and change{
            @purchase.reload
            @purchase.transaction_id
          }
        end
        feature 'emails' do
          before do
            allow(Purchase).to receive(:find).with(@purchase.id.to_s) {@purchase}
          end
          context 'setting send_purchase_emails true' do
            before do
              Setting.get_setting(:send_purchase_emails).update(value: 'true')
            end
            it 'should call send_all_emails on purchase' do
              expect(@purchase).to receive(:send_all_emails)
              post purchase_payment_path(@purchase), params: params
            end
          end
          context 'setting send_purchase_emails not true' do
            before do
              Setting.get_setting(:send_purchase_emails).update(value: 'false')
            end
            it 'should not call send_all_emails' do
              expect(@purchase).to_not receive(:send_all_emails)
              post purchase_payment_path(@purchase), params: params
            end
            it 'should should net flash[:alert]' do
              post purchase_payment_path(@purchase), params: params
              expect(flash[:alert]).to_not be_empty
            end
          end
        end
      end
      context 'invalid card' do
        let(:params) { {card_num: '1234123412341234', exp_date: 1.year.from_now.strftime('%m%y'), ccv: '901'} }
        it 'should redirect to purchase' do
          post purchase_payment_path(@purchase), params: params
          expect(response).to redirect_to purchase_path(@purchase)
        end
        it 'should not change purchase state' do
          post purchase_payment_path(@purchase), params: params
          @purchase.reload
          expect(@purchase).to be_invoiced
        end
        it 'should not change purchase authorization_code' do
          expect{
            post purchase_payment_path(@purchase), params: params
          }.to_not change{
            @purchase.reload
            @purchase.authorization_code
          }
        end
        it 'should not change purchase transaction_id' do
          expect{
            post purchase_payment_path(@purchase), params: params
          }.to_not change{
            @purchase.reload
            @purchase.transaction_id
          }
        end
        it 'should set flash[:alert]' do
          post purchase_payment_path(@purchase), params: params
          expect(flash[:alert]).to_not be_empty
        end
      end
    end
  end
end
