require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  before do
    @reg = FactoryBot.create(:registration)
  end
  context 'Logged Out' do
    describe 'index' do
      it 'should redirect to /login' do
        get registrations_path
        expect(response).to redirect_to '/login'
      end
    end
    describe 'show' do
      it 'should redirect to /login' do
        get registration_path @reg
        expect(response).to redirect_to '/login'
      end
    end
    describe 'new' do
      it 'should redirect to /login' do
        get new_registration_path
        expect(response).to redirect_to '/login'
      end
    end
    describe 'edit' do
      it 'should redirect to /login' do
        get edit_registration_path @reg
        expect(response).to redirect_to '/login'
      end
    end
    describe 'create' do
      before do
        @params = {registration: FactoryBot.attributes_for(:registration, animal_id: @reg.animal.id, registrar_id: @reg.registrar.id)}
      end
      it 'should redirect to /login' do
        post registrations_path, params: @params
        expect(response).to redirect_to '/login'
      end
      it 'should not create registration' do
        expect{
          post registrations_path, params: @params
        }.not_to change(Registration.all, :count)
      end
    end
    describe 'update' do
      before do
        @animal = FactoryBot.create(:animal)
        @params = {registration: FactoryBot.attributes_for(:registration, animal_id: @animal.id, registrar_id: @reg.registrar.id)}
      end
      it 'should redirect to /login' do
        put registration_path @reg, params: @params
        expect(response).to redirect_to '/login'
      end
      it 'should not change the registration' do
        expect{
          put registration_path @reg, params: @params
        }.to_not change(@reg, :animal_id)
      end
    end
  end
  context 'Logged In as admin' do
    before do
      post '/login', params: {email: 'test@test.com', password: 'password'}
    end
    describe 'index' do
      it 'should be successfull' do
        get registrations_path
        expect(response).to be_success
      end
    end
    describe 'show' do
      it 'should be successfull' do
        get registration_path @reg
        expect(response).to be_success
      end
    end
    describe 'new' do
      it 'should be successfull' do
        get new_registration_path
        expect(response).to be_success
      end
    end
    describe 'edit' do
      it 'sohuld be successfull' do
        get edit_registration_path @reg
        expect(response).to be_success
      end
    end
    describe 'create' do
      context 'with valid params' do
        before do
          @params = {registration: FactoryBot.attributes_for(:registration, animal_id: @reg.animal.id, registrar_id: @reg.registrar.id)}
        end
        it 'should redirect to the new registration' do
          post registrations_path, params: @params
          expect(request).to redirect_to registration_path Registration.last
        end
        it 'should create new registration' do
          expect {
            post registrations_path, params: @params
          }.to change(Registration.all, :count)
        end
      end
      context 'with invalid params' do
        before do
          @params = {registration: FactoryBot.attributes_for(:registration, registration: nil)}
        end
        it 'should return 200 status' do
          post registrations_path, params: @params
          expect(response).to have_http_status 200
        end
        it 'should not create new registration' do
          expect{
            post registrations_path, params: @params
          }.to_not change(Registration.all, :count)
        end
      end
    end
    describe 'update' do
      context 'with valid params' do
        before do
          @animal = FactoryBot.create(:animal)
          @params = {registration: FactoryBot.attributes_for(:registration, animal_id: @animal.id, registrar_id: @reg.registrar.id)}
        end
        it 'should redirect to the registration' do
          put registration_path @reg, params: @params
          expect(response).to redirect_to registration_path @reg
        end
        it 'should change the registration' do
          expect{
            put registration_path @reg, params: @params
          }.to change{
            @reg.reload
            @reg.animal_id
          }
        end
      end
      context 'with invalid params' do
        before do
          @params = {registration: {registration: nil}}
        end
        it 'should return http status 200' do
          put registration_path @reg, params: @params
          expect(response).to have_http_status 200
        end
        it 'should not update registration' do
          expect{
            put registration_path @reg, params: @params
          }.to_not change{
            @reg.reload
            @reg.registration
          }
        end
      end
    end
  end
end
