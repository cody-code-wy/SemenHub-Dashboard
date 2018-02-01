require 'rails_helper'

RSpec.describe "Commissions", type: :request do
  context 'logged out' do
    describe 'index' do
      it 'should redirect to /login' do
        get commissions_path
        expect(response).to redirect_to '/login'
      end
    end
    describe 'create' do
      before do
        @user = FactoryBot.create(:user)
        @params = {commission_percent: 50}
      end
      it 'should redirect to /login' do #Should it???
        post user_path(@user)+'/commission', params: @params
        expect(response).to redirect_to '/login'
      end
      it 'should not create a commission' do
        expect{
          post user_path(@user)+'/commission', params: @params
        }.to_not change(Commission.all, :count)
      end
    end
    describe 'destroy' do
      before do
        @commission = FactoryBot.create(:commission)
        @user = @commission.user
      end
      it 'should redirect to /login' do
        delete user_path(@user)+'/commission', params: @params
        expect(response).to redirect_to '/login' #Again does this make sence? its only for API
      end
      it 'should not delete the commission' do
        expect{
          delete user_path(@user)+'/commission', params: @params
        }.to_not change(Commission.all, :count)
      end
    end
  end
  context 'Logged In admin' do
    before do
      post '/login', params: {email: 'test@test.com', password: 'password'}
      @commission = FactoryBot.create(:commission)
      @user = @commission.user
      @params = {commission_percent: 50}
    end
    describe 'index' do
      it 'should be successfull' do
        get commissions_path
        expect(response).to be_success
      end
    end
    describe 'create' do
      before do
        @user = FactoryBot.create(:user)
      end
      it 'should be successfull' do
        post user_path(@user)+'/commission', params: @params, headers: {ACCEPT: 'application/json'}
        expect(response).to be_success
      end
      it 'should create new commission if not existing' do
        expect{
          post user_path(@user)+'/commission', params: @params, headers: {ACCEPT: 'application/json'}
        }.to change(Commission.all, :count)
      end
      it 'should update existing commission if existing' do
        @user = FactoryBot.create(:user, :with_commission)
        expect{
          post user_path(@user)+'/commission', params: @params, headers: {ACCEPT: 'application/json'}
        }.to change{
          @user.commission.reload
          @user.commission.commission_percent
        }
      end
      it 'should return bad request with invalid parameter' do
        post user_path(@user)+'/commission', params: {commission_percent: 'Not a Number'}, headers: {ACCEPT: 'application/json'}
        expect(response).to have_http_status :bad_request
      end
      it 'should return internal server error when ????' do
        post user_path(@user)+'/commission', params: {commission_percent: 150}, headers: {ACCEPT: 'application/json'}
        expect(response).to have_http_status :internal_server_error
      end
    end
    describe 'destroy' do
      it 'should be success' do
        delete user_path(@user)+'/commission'
        expect(response).to be_success
      end
      it 'should remove commission from user' do
        expect{
          delete user_path(@user)+'/commission'
        }.to change(Commission.all, :count)
      end
      it 'should be success on user without commission' do
        @user = FactoryBot.create(:user)
        delete user_path(@user)+'/commission'
        expect(response).to be_success
      end
    end
  end
end
