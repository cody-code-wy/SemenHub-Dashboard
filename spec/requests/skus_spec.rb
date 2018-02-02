require 'rails_helper'

RSpec.describe "Skus", type: :request do
  context 'logged out' do
    before do
      @sku = FactoryBot.create(:sku)
    end
    describe 'index' do
      it 'should redirect to /login' do
        get skus_path
        expect(response).to redirect_to '/login'
      end
    end
    describe 'show' do
      it 'should redirect to /login' do
        get sku_path(@sku)
        expect(response).to redirect_to '/login'
      end
    end
    describe 'new' do
      it 'should redirect to /login' do
        get new_sku_path
        expect(response).to redirect_to '/login'
      end
    end
    describe 'edit' do
      it 'should redirect to /login' do
        get edit_sku_path(@sku)
        expect(response).to redirect_to '/login'
      end
    end
    describe 'create' do
      before do
        @params = {sku: FactoryBot.attributes_for(:sku, animal_id: @sku.animal_id, seller_id: @sku.seller_id, storagefacility_id: @sku.storagefacility_id)}
      end
      it 'should redirect to /login' do
        post skus_path, params: @params
        expect(response).to redirect_to '/login'
      end
      it 'should not create a sku' do
        expect{
          post skus_path, params: @params
        }.to_not change(Sku.all, :count)
      end
    end
    describe 'update' do
      before do
        @seller = FactoryBot.create(:user)
        @params = {sku: FactoryBot.attributes_for(:sku, animal_id: @sku.animal_id, seller_id: @seller.id, storagefacility_id: @sku.storagefacility_id)}
      end
      it 'should redirect to /login' do
        put sku_path(@sku), params: @params
        expect(response).to redirect_to '/login'
      end
      it 'should not update the sku' do
        expect{
          put sku_path(@sku), params: @params
        }.to_not change{
          @sku.reload
          @sku.seller_id
        }
      end
    end
    describe 'destroy' do
      it 'should redirect to /login' do
        delete sku_path(@sku), params: @params
        expect(response).to redirect_to '/login'
      end
      it 'should not delete the sku' do
        expect{
          delete sku_path(@sku), params: @params
        }.to_not change(Sku.all, :count)
      end
    end
  end
  context 'Logged In' do
    before do
      post '/login', params: {email: 'test@test.com', password: 'password'}
      @sku = FactoryBot.create(:sku)
    end
    describe 'index' do
      it 'should be success' do
        get skus_path
        expect(response).to be_success
      end
    end
    describe 'show' do
      it 'should be success' do
        get sku_path(@sku)
        expect(response).to be_success
      end
    end
    describe 'now' do
      it 'should be success' do
        get new_sku_path
        expect(response).to be_success
      end
    end
    describe 'edit' do
      it 'should be success' do
        get edit_sku_path(@sku)
        expect(response).to be_success
      end
    end
    describe 'create' do
      context 'valid params' do
        before do
          @params = {sku: FactoryBot.attributes_for(:sku, animal_id: @sku.animal_id, seller_id: @sku.seller_id, storagefacility_id: @sku.storagefacility_id)}
        end
        it 'should redirect to the new sku' do
          post skus_path, params: @params
          expect(response).to redirect_to sku_path(Sku.last)
        end
        it 'should create a new sku' do
          expect{
            post skus_path, params: @params
          }.to change(Sku.all, :count)
        end
        it 'should respond to json' do
          post skus_path, params: @params, headers: {ACCEPT: 'application/json'}
          expect(response.header['Content-Type']).to include 'application/json'
        end
      end
      context 'invalid params' do
        before do
          @params = {sku: FactoryBot.attributes_for(:sku, price_per_unit: nil, animal_id: @sku.animal_id, seller_id: @sku.seller_id, storagefacility_id: @sku.storagefacility_id)}
        end
        it 'should return http 200 status' do
          post skus_path, params: @params
          expect(response).to have_http_status 200
        end
        it 'should not create a new sku' do
          expect{
            post skus_path, params: @params
          }.to_not change(Sku.all, :count)
        end
        it 'should respond with :unprocessable_entity' do
          post skus_path, params: @params, headers: {ACCEPT: 'application/json'}
          expect(response.header['Content-Type']).to include 'application/json'
        end
      end
    end
    describe 'update' do
      context 'valid params' do
        before do
          @owner = FactoryBot.create(:user)
          @params = {sku: FactoryBot.attributes_for(:sku, animal_id: @sku.animal_id, seller_id: @owner.id, storagefacility_id: @sku.storagefacility_id)}
        end
        it 'should redirect to the sku' do
          put sku_path(@sku), params: @params
          expect(response).to redirect_to sku_path(@sku)
        end
        it 'should update the sku' do
          expect{
            put sku_path(@sku), params: @params
          }.to change{
            @sku.reload
            @sku.seller_id
          }
        end
        it 'should respond to json' do
          put sku_path(@sku), params: @params, headers: {ACCEPT: 'application/json'}
          expect(response.header['Content-Type']).to include 'application/json'
        end
      end
      context 'invalid params' do
        before do
          @seller = FactoryBot.create(:user)
          @params = {sku: FactoryBot.attributes_for(:sku, price_per_unit: nil, animal_id: @sku.animal_id, seller_id: @seller.id, storagefacility_id: @sku.storagefacility_id)}
        end
        it 'should return http status 200' do
          put sku_path(@sku), params: @params
          expect(response).to have_http_status 200
        end
        it 'should not update the sku' do
          expect{
            put sku_path(@sku), params: @params
          }.to_not change{
            @sku.reload
            @sku.seller_id
          }
        end
        it 'should respond with :unprocessable_entity' do
          put sku_path(@sku), params: @params, headers: {ACCEPT: 'application/json'}
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
    describe 'destroy' do
      it 'should redirect to index' do
        delete sku_path(@sku)
        expect(response).to redirect_to skus_path
      end
      it 'should delete the sku' do
        expect{
          delete sku_path(@sku)
        }.to change(Sku.all, :count)
      end
      it 'should respond with :no_content' do
        delete sku_path(@sku), headers: {ACCEPT: 'application/json'}
        expect(response).to have_http_status :no_content
      end
    end
  end
end
