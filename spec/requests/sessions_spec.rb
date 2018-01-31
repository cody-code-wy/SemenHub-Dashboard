require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  context 'Logged Out' do
    describe 'new' do
      it 'Should return success response' do
        get '/login'
        expect(response).to be_success
      end
    end
    describe 'create' do
      it 'Should update session with valid credentials' do
        post '/login', params: {email: 'test@test.com', password: 'password'}
        expect(request.env['rack.session'][:user_id]).to eq User.first.id
      end
      it 'Should redirect to / with session[:login_redirect] not set' do
        post '/login', params: {email: 'test@test.com', password: 'password'}
        expect(response).to redirect_to '/'
      end
      it 'Should redirect to session[:login_redirect] if set' do
        get '/animals' # set login_redirect
        post '/login', params: {email: 'test@test.com', password: 'password'}
        expect(response).to redirect_to '/animals'
      end
      it 'Should not update session with invalid credentials' do
        post '/login', params: {email: 'test@test.com', password: 'wrong'}
        expect(request.env['rack.session'][:user_id]).to be_nil
      end
      it 'Should redirect to /login with invalid credentials' do
        post '/login', params: {email: 'test@test.com', password: 'wrong'}
        expect(response).to redirect_to '/login'
      end
    end
    describe 'destroy' do
      it 'Should redirect to /login' do
        get '/logout'
        expect(response).to redirect_to '/login'
      end
    end
  end
  context 'Logged In' do
    before do
      post '/login', params: {email: 'test@test.com', password: 'password'}
      expect(request.env['rack.session'][:user_id]).to eq User.first.id # Sanity Check
    end
    describe 'new' do
      it 'Should redirect to /' do
        get '/login'
        expect(response).to redirect_to '/'
      end
    end
    describe 'create' do
      before do
        @user = FactoryBot.create(:user, password: 'password', password_confirmation: 'password')
      end
      context 'With valid credentials' do
        it 'Should redirect to /' do
          post '/login', params: {email: @user.email, password: 'password'}
          expect(response).to redirect_to '/'
        end
        it 'Should not update session' do
          post '/login', params: {email: @user.email, password: 'password'}
          expect(request.env['rack.session'][:user_id]).to eq User.first.id
        end
      end
      context 'With invalid credentials' do
        it 'Should redirect to / with invalid credentials' do
          post '/login', params: {email: @user.email, password: 'wrong'}
          expect(response).to redirect_to '/'
        end
        it 'Should not update session with invalid credentials' do
          post '/login', params: {email: @user.email, password: 'wrong'}
          expect(request.env['rack.session'][:user_id]).to eq User.first.id
        end
      end
    end
    describe 'destroy' do
      it 'should redirect to /login' do
        get '/logout'
        expect(response).to redirect_to '/login'
      end
      it 'should remove user from session' do
        get '/logout'
        expect(request.env['rack.session'][:user_id]).to be_nil
      end
    end
  end
end
