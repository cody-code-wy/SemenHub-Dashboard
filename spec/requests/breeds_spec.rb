require 'rails_helper'

RSpec.describe "Breeds", type: :request do
  context 'Logged Out' do
    before do
      @breed = FactoryBot.create(:breed)
    end
    describe 'index' do
      it 'should redirect to /login' do
        get breeds_path
        expect(response).to redirect_to '/login'
      end
    end
    describe 'show' do
      it 'should redirect to /login' do
        get breed_path @breed
        expect(response).to redirect_to '/login'
      end
    end
    describe 'new' do
      it 'should redirect to /login' do
        get new_breed_path
        expect(response).to redirect_to '/login'
      end
    end
    describe 'edit' do
      it 'should redirect to /login' do
        get edit_breed_path @breed
        expect(response).to redirect_to '/login'
      end
    end
    describe 'create' do
      before do
        @params = {breed: FactoryBot.attributes_for(:breed)}
      end
      it 'should redirect to /login' do
        post breeds_path, params: @params
        expect(response).to redirect_to '/login'
      end
      it 'should not create a breed' do
        expect{
          post breeds_path, params: @params
        }.to_not change(Breed.all, :count)
      end
    end
    describe 'update' do
      before do
        @params = {breed: FactoryBot.attributes_for(:breed)}
      end
      it 'should redirect to /login' do
        put breed_path @breed, params: @params
        expect(response).to redirect_to '/login'
      end
      it 'should not update breed' do
        expect{
          put breed_path @breed, params: @params
        }.to_not change{
          @breed.reload
          @breed.breed_name
        }
      end
    end
    describe 'destroy' do
      it 'should redirect to /login' do
        delete breed_path @breed
        expect(response).to redirect_to '/login'
      end
      it 'should not remove breed' do
        expect{
          delete breed_path @breed
        }.to_not change(Breed.all, :count)
      end
    end
  end
  context 'Logged In' do
    before do
      post '/login', params: {email: 'admin@test.com', password: 'password'}
      @breed = FactoryBot.create(:breed)
    end
    describe 'index' do
      it 'should be success' do
        get breeds_path
        expect(response).to be_success
      end
    end
    describe 'show' do
      it 'should be success' do
        get breed_path @breed
        expect(response).to be_success
      end
    end
    describe 'new' do
      it 'should be success' do
        get new_breed_path
        expect(response).to be_success
      end
    end
    describe 'edit' do
      it 'should be success' do
        get edit_breed_path @breed
        expect(response).to be_success
      end
    end
    describe 'create' do
      context 'with valid params' do
        before do
          @params = {breed: FactoryBot.attributes_for(:breed)}
        end
        it 'should redirect to new breed' do
          post breeds_path, params: @params
          expect(response).to redirect_to breed_path Breed.last
        end
        it 'should create a new breed' do
          expect{
            post breeds_path, params: @params
          }.to change(Breed.all, :count)
        end
        it 'should respond with json' do
          post breeds_path, params: @params, headers: {ACCEPT: 'application/json'}
          expect(response.header['Content-Type']).to include 'application/json'
        end
      end
      context 'with invalid params' do
        before do
          @params = {breed: {breed_name: ''}}
        end
        it 'should return http 200' do
          post breeds_path, params: @params
          expect(response).to have_http_status 200
        end
        it 'should not create a new breed' do
          expect{
            post breeds_path, params: @params
          }.to_not change(Breed.all, :count)
        end
        it 'should return :unprocessable_entity for json' do
          post breeds_path, params: @params, headers: {ACCEPT: 'application/json'}
          expect(response).to have_http_status :unprocessable_entity
        end
        it 'should respond with json' do
          post breeds_path, params: @params, headers: {ACCEPT: 'application/json'}
          expect(response.header['Content-Type']).to include 'application/json'
        end
      end
    end
    describe 'update' do
      context 'with valid params' do
        before do
          @params = {breed: {breed_name: 'new breed'}}
        end
        it 'should redirect to breed' do
          put breed_path @breed, params: @params
          expect(response).to redirect_to breed_path
        end
        it 'should update the breed' do
          expect{
            put breed_path @breed, params: @params
          }.to change{
            @breed.reload
            @breed.breed_name
          }
        end
        it 'should respond with json' do
          put breed_path(@breed), params: @params, headers: {ACCEPT: 'application/json'}
          expect(response.header['Content-Type']).to include 'application/json'
        end
      end
      context 'with invalid params' do
        before do
          @params = {breed: {breed_name: ''}}
        end
        it 'should return http 200 response' do
          put breed_path @breed, params: @params
          expect(response).to have_http_status 200
        end
        it 'should not update the breed' do
          expect{
            put breed_path @breed, params: @params
          }.to_not change{
            @breed.reload
            @breed.breed_name
          }
        end
        it 'should respond with json' do
          put breed_path(@breed), params: @params, headers: {ACCEPT: 'application/json'}
          expect(response.header['Content-Type']).to include 'application/json'
        end
        it 'shourd return :unprocessable_entity with json' do
          put breed_path(@breed), params: @params, headers: {ACCEPT: 'application/json'}
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end
    describe 'destroy' do
      it 'should redirect to breeds_path' do
        delete breed_path(@breed)
        expect(response).to redirect_to breeds_path
      end
      it 'should remove breed' do
        expect{
          delete breed_path(@breed)
        }.to change(Breed.all, :count)
      end
      it 'should return :no_content with json' do
        delete breed_path(@breed), headers: {ACCEPT: 'application/json'}
        expect(response).to have_http_status :no_content
      end
    end
  end
end
