require 'rails_helper'

RSpec.describe "InventoryTransactions", type: :request do
  context 'logged out' do
    before do
      @trans = FactoryBot.create(:inventory_transaction)
    end
    describe 'index' do
      it 'should redirect to /login' do
        get inventory_transactions_path
        expect(response).to redirect_to '/login'
      end
    end
    describe 'new' do
      it 'should redirect to /login' do
        get new_inventory_transaction_path
        expect(response).to redirect_to '/login'
      end
    end
    describe 'show' do
      it 'should redirect to /login' do
        get inventory_transaction_path(@trans)
        expect(response).to redirect_to '/login'
      end
    end
    describe 'create' do
      before do
        @params = {inventory_transaction: FactoryBot.attributes_for(:inventory_transaction)}
        @params[:inventory_transaction][:sku] = FactoryBot.attributes_for(:sku, animal_id: @trans.sku.animal_id, storagefacility_id: @trans.sku.storagefacility_id, seller_id: @trans.sku.seller_id)
      end
      it 'should redirect to /login' do
        post inventory_transactions_path, params: @params
        expect(response).to redirect_to '/login'
      end
      it 'should not create inventory transaction' do
        expect{
          post inventory_transactions_path, params: @params
        }.to_not change(InventoryTransaction.all, :count)
      end
    end
    describe 'edit' do
      it 'should redirect to /login' do
        get edit_inventory_transaction_path(@trans)
        expect(response).to redirect_to '/login'
      end
    end
    describe 'update' do
      before do
        @params = {inventory_transaction: FactoryBot.attributes_for(:inventory_transaction)}
        @params[:inventory_transaction][:sku] = @trans.sku.attributes
      end
      it 'should redirect to /login' do
        put inventory_transaction_path(@trans), params: @params
        expect(response).to redirect_to '/login'
      end
      it 'should not update inventory transaction' do
        expect{
          put inventory_transaction_path(@trans), params: @params
        }.to_not change{
          @trans.reload
          @trans.quantity
        }
      end
    end
  end
  context 'Logged In' do
    before do
      post '/login', params: {email: 'admin@test.com', password: 'password'}
      @trans = FactoryBot.create(:inventory_transaction)
    end
    describe 'index' do
      it 'should be success' do
        get inventory_transactions_path
        expect(response).to be_success
      end
    end
    describe 'new' do
      context 'without existing sku' do
        it 'should be success' do
          get new_inventory_transaction_path
          expect(response).to be_success
        end
      end
      context 'with existing sku' do
        it 'should be success' do
          get new_inventory_transaction_path, params: {sku_id: @trans.sku.id}
          expect(response).to be_success
        end
      end
    end
    describe 'show' do
      it 'should be success' do
        get inventory_transaction_path(@trans)
        expect(response).to be_success
      end
    end
    describe 'create' do
      context 'with valid params' do
        before do
          @params = {inventory_transaction: FactoryBot.attributes_for(:inventory_transaction)}
        end
        context 'without existing sku' do
          before do
            @params[:inventory_transaction][:sku] = FactoryBot.attributes_for(:sku, animal_id: @trans.sku.animal_id, storagefacility_id: @trans.sku.storagefacility_id, seller_id: @trans.sku.seller_id)
          end
          it 'should create inventory transaction' do
            expect{
              post inventory_transactions_path, params: @params
            }.to change(InventoryTransaction.all, :count)
          end
          it 'should create sku' do
            expect{
              post inventory_transactions_path, params: @params
            }.to change(Sku.all, :count)
          end
          it 'should have sku on inventory transaction' do
            post inventory_transactions_path, params: @params
            expect(InventoryTransaction.last.sku).to eq Sku.last
          end
          it 'should redirect to the transaction' do
            post inventory_transactions_path, params: @params
            expect(response).to redirect_to inventory_transaction_path(InventoryTransaction.last)
          end
        end
        context 'with existing sku' do
          before do
            @params[:inventory_transaction][:sku] = @trans.sku.attributes
          end
          it 'should create inventory transaction' do
            expect{
              post inventory_transactions_path, params: @params
            }.to change(InventoryTransaction.all, :count)
          end
          it 'should not create sku' do
            expect{
              post inventory_transactions_path, params: @params
            }.to_not change(Sku.all, :count)
          end
          it 'should add correct sku to inventory transaction' do
            post inventory_transactions_path, params: @params
            expect(InventoryTransaction.last.sku).to eq @trans.sku
          end
          it 'should redirect to the transaction' do
            post inventory_transactions_path, params: @params
            expect(response).to redirect_to inventory_transaction_path(InventoryTransaction.last)
          end
        end
      end
      context 'with invalid invtrans params' do
        before do
          @params = {inventory_transaction: FactoryBot.attributes_for(:inventory_transaction, quantity: nil)}
        end
        context 'without existing sku' do
          before do
            @params[:inventory_transaction][:sku] = FactoryBot.attributes_for(:sku, animal_id: @trans.sku.animal_id, storagefacility_id: @trans.sku.storagefacility_id, seller_id: @trans.sku.seller_id)
          end
          it 'should return http 200 status' do
            post inventory_transactions_path, params: @params
            expect(response).to have_http_status 200
          end
          it 'should not create inventory transaction' do
            expect{
              post inventory_transactions_path, params: @params
            }.to_not change(InventoryTransaction.all, :count)
          end
          it 'should not create sku' do
            expect{
              post inventory_transactions_path, params: @params
            }.to_not change(Sku.all, :count)
          end
        end
        context 'with existing sku' do
          before do
            @params[:inventory_transaction][:sku] = @trans.sku.attributes
          end
          it 'should return http 200 status' do
            post inventory_transactions_path, params: @params
            expect(response).to have_http_status 200
          end
          it 'should not create inventory transaction' do
            expect{
              post inventory_transactions_path, params: @params
            }.to_not change(InventoryTransaction.all, :count)
          end
          it 'sohuld not create a sku' do
            expect{
              post inventory_transactions_path, params: @params
            }.to_not change(Sku.all, :count)
          end
        end
      end
      context 'with invalid sku params' do
        before do
          @params = {inventory_transaction: FactoryBot.attributes_for(:inventory_transaction)}
          @params[:inventory_transaction][:sku] = FactoryBot.attributes_for(:sku, price_per_unit: nil)
        end
        it 'should return http 200 status' do
          post inventory_transactions_path, params: @params
          expect(response).to have_http_status 200
        end
        it 'should not create inventory transaction' do
          expect{
            post inventory_transactions_path, params: @params
          }.to_not change(InventoryTransaction.all, :count)
        end
        it 'should not create sku' do
          expect{
            post inventory_transactions_path, params: @params
          }.to_not change(Sku.all, :count)
        end
      end
      context 'with all invalid params' do
        before do
          @params = {inventory_transaction: FactoryBot.attributes_for(:inventory_transaction, quantity: nil)}
          @params[:inventory_transaction][:sku] = FactoryBot.attributes_for(:sku, price_per_unit: nil)
        end
        it 'should not create inventory transaction' do
          expect{
            post inventory_transactions_path, params: @params
          }.to_not change(InventoryTransaction.all, :count)
        end
        it 'should not create sku' do
          expect{
            post inventory_transactions_path, params: @params
          }.to_not change(Sku.all, :count)
        end
        it 'should return http 200 status' do
          post inventory_transactions_path, params: @params
          expect(response).to have_http_status 200
        end
      end
    end
    describe 'edit' do
      it 'should be sucessfull' do
        get edit_inventory_transaction_path(@trans)
        expect(response).to be_success
      end
    end
    describe 'update' do
      context 'with valid params' do
        before do
          @params = {inventory_transaction: FactoryBot.attributes_for(:inventory_transaction)}
        end
        context 'without existing sku' do
          before do
            @params[:inventory_transaction][:sku] = FactoryBot.attributes_for(:sku, animal_id: @trans.sku.animal_id, storagefacility_id: @trans.sku.storagefacility_id, seller_id: @trans.sku.seller_id)
          end
          it 'should update inventory transaction' do
            expect{
              put inventory_transaction_path(@trans), params: @params
            }.to change{
              @trans.reload
              @trans.quantity
            }
          end
          it 'should create sku' do
            expect{
              put inventory_transaction_path(@trans), params: @params
            }.to change(Sku.all, :count)
          end
          it 'should have sku on inventory transaction' do
            put inventory_transaction_path(@trans), params: @params
            @trans.reload
            expect(@trans.sku).to eq Sku.last
          end
          it 'should redirect to the transaction' do
            put inventory_transaction_path(@trans), params: @params
            expect(response).to redirect_to inventory_transaction_path(@trans)
          end
        end
        context 'with existing sku' do
          before do
            @params[:inventory_transaction][:sku] = @trans.sku.attributes
            @sku = @trans.sku
          end
          it 'should update inventory transaction' do
            expect{
              put inventory_transaction_path(@trans), params: @params
            }.to change{
              @trans.reload
              @trans.quantity
            }
          end
          it 'should not create sku' do
            expect{
              put inventory_transaction_path(@trans), params: @params
            }.to_not change(Sku.all, :count)
          end
          it 'should add correct sku to inventory transaction' do
            put inventory_transaction_path(@trans), params: @params
            @trans.reload
            expect(@trans.sku).to eq @sku
          end
          it 'should redirect to the transaction' do
            put inventory_transaction_path(@trans), params: @params
            expect(response).to redirect_to inventory_transaction_path(@trans)
          end
        end
      end
      context 'with invalid invtrans params' do
        before do
          @params = {inventory_transaction: FactoryBot.attributes_for(:inventory_transaction, quantity: nil)}
        end
        context 'without existing sku' do
          before do
            @params[:inventory_transaction][:sku] = FactoryBot.attributes_for(:sku, animal_id: @trans.sku.animal_id, storagefacility_id: @trans.sku.storagefacility_id, seller_id: @trans.sku.seller_id)
          end
          it 'should return http 200 status' do
            put inventory_transaction_path(@trans), params: @params
            expect(response).to have_http_status 200
          end
          it 'should not update inventory transaction' do
            expect{
              put inventory_transaction_path(@trans), params: @params
            }.to_not change{
              @trans.reload
              @trans.quantity
            }
          end
          it 'should not create sku' do
            expect{
              put inventory_transaction_path(@trans), params: @params
            }.to_not change(Sku.all, :count)
          end
        end
        context 'with existing sku' do
          before do
            @params[:inventory_transaction][:sku] = @trans.sku.attributes
          end
          it 'should return http 200 status' do
            put inventory_transaction_path(@trans), params: @params
            expect(response).to have_http_status 200
          end
          it 'should not update inventory transaction' do
            expect{
              put inventory_transaction_path(@trans), params: @params
            }.to_not change{
              @trans.reload
              @trans.quantity
            }
          end
          it 'should not create sku' do
            expect{
              put inventory_transaction_path(@trans), params: @params
            }.to_not change(Sku.all, :count)
          end
        end
      end
      context 'with invalid sku params' do
        before do
          @params = {inventory_transaction: FactoryBot.attributes_for(:inventory_transaction)}
          @params[:inventory_transaction][:sku] = FactoryBot.attributes_for(:sku, price_per_unit: nil)
        end
        it 'should return http 200 status' do
          put inventory_transaction_path(@trans), params: @params
          expect(response).to have_http_status 200
        end
        it 'should not update inventory transaction' do
          expect{
            put inventory_transaction_path(@trans), params: @params
          }.to_not change{
            @trans.reload
            @trans.quantity
          }
        end
        it 'should not create sku' do
          expect{
            put inventory_transaction_path(@trans), params: @params
          }.to_not change(Sku.all, :count)
        end
      end
      context 'with all invalid params' do
        before do
          @params = {inventory_transaction: FactoryBot.attributes_for(:inventory_transaction, quantity: nil)}
          @params[:inventory_transaction][:sku] = FactoryBot.attributes_for(:sku, price_per_unit: nil)
        end
        it 'should return http 200 status' do
          put inventory_transaction_path(@trans), params: @params
          expect(response).to have_http_status 200
        end
        it 'should not update inventory transaction' do
          expect{
            put inventory_transaction_path(@trans), params: @params
          }.to_not change{
            @trans.reload
            @trans.quantity
          }
        end
        it 'should not create sku' do
          expect{
            put inventory_transaction_path(@trans), params: @params
          }.to_not change(Sku.all, :count)
        end
      end
    end
  end
end
