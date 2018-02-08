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
    describe 'payment' do
      it 'should redirect to /login' do
        post purchase_path(@purchase)+'/payment'
        expect(response).to redirect_to '/login'
      end
    end
    pending 'finish purchases request spec after refactor'
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
    pending 'finish purchases request spec after refactor'
  end
end
