require 'rails_helper'

RSpec.describe "Fees", type: :request do
  context 'logged out' do
    before do
      @fee = FactoryBot.create(:fee)
    end
    describe 'index' do
      it 'should redirect to /login' do
        get fees_path
        expect(response).to redirect_to '/login'
      end
    end
    describe 'show' do
      it 'should redirect to /login' do
        get fee_path(@fee)
        expect(response).to redirect_to '/login'
      end
    end
    describe 'new' do
      it 'should redirect to /login' do
        get new_fee_path
        expect(response).to redirect_to '/login'
      end
    end
    describe 'edit' do
      it 'should redirect to /login' do
        get edit_fee_path(@fee)
        expect(response).to redirect_to '/login'
      end
    end
    describe 'create' do
      before do
        @params = {fee: FactoryBot.attributes_for(:fee, storage_facitity_id: @fee.storage_facility_id)}
      end
      it 'should redirect to /login' do
        post fees_path, params: @params
        expect(response).to redirect_to '/login'
      end
      it 'should not create fee' do
        expect{
          post fees_path, params: @params
        }.to_not change(Fee.all, :count)
      end
    end
    describe 'update' do
      before do
        @params = {fee: FactoryBot.attributes_for(:fee, storage_facility_id: @fee.storage_facility_id)}
      end
      it 'should redirect to /login' do
        put fee_path(@fee), params: @params
        expect(response).to redirect_to '/login'
      end
      it 'should not update the fee' do
        expect{
          put fee_path(@fee), params: @params
        }.to_not change{
          @fee.reload
          @fee.price
        }
      end
    end
    describe 'destroy' do
      it 'should redirect to /login' do
        delete fee_path(@fee)
        expect(response).to redirect_to '/login'
      end
      it 'should not delete the fee' do
        expect{
          delete fee_path(@fee)
        }.to_not change(Fee.all, :count)
      end
    end
  end
  context 'logged in' do
    before do
      post '/login', params: {email: 'test@test.com', password: 'password'}
      @fee = FactoryBot.create(:fee)
    end
    describe 'index' do
      it 'should be success' do
        get fees_path
        expect(response).to be_success
      end
    end
    describe 'show' do
      it 'should be success' do
        get fee_path(@fee)
        expect(response).to be_success
      end
    end
    describe 'new' do
      it 'should be success' do
        get new_fee_path
        expect(response).to be_success
      end
    end
    describe 'edit' do
      it 'should be success' do
        get edit_fee_path(@fee)
        expect(response).to be_success
      end
    end
    describe 'create' do
      context 'valid params' do
        before do
          @params = {fee: FactoryBot.attributes_for(:fee, storage_facility_id: @fee.storage_facility_id)}
        end
        it 'should redirect to the fee' do
          post fees_path, params: @params
          expect(response).to redirect_to fee_path(Fee.last)
        end
        it 'should create a new fee' do
          expect{
            post fees_path, params: @params
          }.to change(Fee.all, :count)
        end
        it 'should respond with json' do
          post fees_path, params: @params, headers: {ACCEPT: 'application/json'}
          expect(response.header['Content-Type']).to include 'application/json'
        end
      end
      context 'invalid params' do
        before do
          @params = {fee: FactoryBot.attributes_for(:fee, storage_facility_id: @fee.storage_facility_id, price: nil)}
        end
        it 'should return http 200' do
          post fees_path, params: @params
          expect(response).to have_http_status 200
        end
        it 'should not create a fee' do
          expect{
            post fees_path, params: @params
          }.to_not change(Fee.all, :count)
        end
        it 'should respond with unprocessable_entity' do
          post fees_path, params: @params, headers: {ACCEPT: 'application/json'}
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
    describe 'update' do
      context 'valid params' do
        before do
          @params = {fee: FactoryBot.attributes_for(:fee, storage_facility_id: @fee.storage_facility_id)}
        end
        it 'should redirect to fee' do
          put fee_path(@fee), params: @params
          expect(response).to redirect_to fee_path(@fee)
        end
        it 'should update the fee' do
          expect{
            put fee_path(@fee), params: @params
          }.to change{
            @fee.reload
            @fee.price
          }
        end
        it 'should respond with json' do
          put fee_path(@fee), params: @params, headers: {ACCEPT: 'application/json'}
          expect(response.header['Content-Type']).to include 'application/json'
        end
      end
      context 'invalid params' do
        before do
          @params = {fee: FactoryBot.attributes_for(:fee, storage_facility_id: @fee.storage_facility_id, price: nil)}
        end
        it 'should return http 200' do
          put fee_path(@fee), params: @params
          expect(response).to have_http_status 200
        end
        it 'should not update the fee' do
          expect{
            put fee_path(@fee), params: @params
          }.to_not change{
            @fee.reload
            @fee.price
          }
        end
        it 'should respond with :unprocessable_entity' do
          put fee_path(@fee), params: @params, headers: {ACCEPT: 'application/json'}
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
    describe 'destroy' do
      it 'should redirect to index' do
        delete fee_path(@fee)
        expect(response).to redirect_to fees_path
      end
      it 'should delete fee' do
        expect{
          delete fee_path(@fee)
        }.to change(Fee.all, :count)
      end
      it 'should respond with :no_content' do
        delete fee_path(@fee), headers: {ACCEPT: 'application/json'}
        expect(response).to have_http_status :no_content
      end
    end
  end
end
