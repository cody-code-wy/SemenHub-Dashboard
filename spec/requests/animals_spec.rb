require 'rails_helper'

RSpec.describe "Animals", type: :request do
  context 'Logged Out' do
    before do
      @animal = FactoryBot.create(:animal, :with_sire, :with_dam)
    end
    describe 'index' do
      it 'should redirect to /login' do
        get animals_path
        expect(response).to redirect_to '/login'
      end
    end
    describe 'show' do
      it 'should redirect to /login' do
        get animal_path(@animal)
        expect(response).to redirect_to '/login'
      end
    end
    describe 'repl' do
      it 'should be successfull' do
        get animal_path(@animal)+'/repl', headers: {ACCEPT: 'application/json'}
        expect(response).to be_success
      end
      it 'should have json mime' do
        get animal_path(@animal)+'/repl', headers: {ACCEPT: 'application/json'}
        expect(response.header['Content-Type']).to include 'application/json'
      end
      it 'should ve javascript mime with callback param' do
        get animal_path(@animal)+'/repl', params: {callback: 'callback'}, headers: {ACCEPT: 'application/json'}
        expect(response.header['Content-Type']).to include 'text/javascript'
      end
    end
    describe 'new' do
      it 'should redirect to /login' do
        get new_animal_path
        expect(response).to redirect_to '/login'
      end
    end
    describe 'edit' do
      it 'should redirect to /login' do
        get edit_animal_path(@animal)
        expect(response).to redirect_to '/login'
      end
    end
    describe 'create' do
      before do
        @params = {animal: FactoryBot.attributes_for(:animal, owner_id: @animal.owner_id, breed_id: @animal.breed_id)}
      end
      it 'should redirect to /login' do
        post animals_path, params: @params
        expect(response).to redirect_to '/login'
      end
      it 'should not create an animal' do
        expect{
          post animals_path, params: @params
        }.to_not change(Animal.all, :count)
      end
    end
    describe 'update' do
      before do
        @params = {animal: FactoryBot.attributes_for(:animal, owner_id: @animal.owner_id, breed_id: @animal.breed_id)}
      end
      it 'should redirect to /login' do
        put animal_path(@animal), params: @params
        expect(response).to redirect_to '/login'
      end
      it 'should not update animal' do
        expect{
          put animal_path(@animal), params: @params
        }.to_not change{
          @animal.reload
          @animal.name
        }
      end
    end
    describe 'destroy' do
      it 'should redirect to /login' do
        delete animal_path(@animal)
        expect(response).to redirect_to '/login'
      end
      it 'should not delete the animal' do
        expect{
          delete animal_path(@animal)
        }.to_not change(Animal.all, :count)
      end
    end
  end
  context 'Logged In' do
    before do
      @animal = FactoryBot.create(:animal)
      post '/login', params: {email: 'test@test.com', password: 'password'}
    end
    describe 'index' do
      it 'should be success' do
        get animals_path
        expect(response).to have_http_status 200
        expect(response).to be_success
      end
    end
    describe 'show' do
      it 'should be success' do
        get animal_path(@animal)
        expect(response).to be_success
      end
    end
    describe 'repl' do
      it 'should be success' do
        get animal_path(@animal)+'/repl', headers: {ACCEPT: 'application/json'}
        expect(response).to be_success
      end
    end
    describe 'new' do
      it 'should be success' do
        get new_animal_path
        expect(response).to be_success
      end
    end
    describe 'edit' do
      it 'should be success' do
        get edit_animal_path(@animal)
        expect(response).to be_success
      end
    end
    describe 'create' do
      context 'valid params' do
        before do
          @params = {animal: FactoryBot.attributes_for(:animal, owner_id: @animal.owner_id, breed_id: @animal.breed_id)}
        end
        it 'should redirect to animal' do
          post animals_path, params: @params
          expect(response).to redirect_to animal_path(Animal.last)
        end
        it 'should create new animal' do
          expect{
            post animals_path, params: @params
          }.to change(Animal.all, :count)
        end
        context 'with sire' do
          it 'should create new animal with no sire' do
            @params[:animal][:sire_id] = ""
            post animals_path, params: @params
            expect(Animal.last.sire).to be_nil
          end
          it 'should create new animal with sire' do
            @sire = FactoryBot.create(:animal, is_male: true)
            @params[:animal][:sire_id] = "#{@sire.id}"
            post animals_path, params: @params
            expect(Animal.last.sire).to eq @sire
          end
        end
        context 'with dam' do
          it 'should create new animal with no dam' do
            @params[:animal][:dam_id] = ""
            post animals_path, params: @params
            expect(Animal.last.dam).to be_nil
          end
          it 'should create new animal with dam' do
            @dam = FactoryBot.create(:animal, is_male: false)
            @params[:animal][:dam_id] = "#{@dam.id}"
            post animals_path, params: @params
            expect(Animal.last.dam).to eq @dam
          end
        end
        context 'with registration' do
          before do
            @breed = @animal.breed
            @reg = FactoryBot.create(:registrar, breed: @breed)
            @params[:registrations] = {@reg.name.parameterize => FactoryBot.attributes_for(:registration)}
          end
          it 'sohuld redirect to animal' do
            post animals_path, params: @params
            expect(response).to redirect_to animal_path(Animal.last)
          end
          it 'should create registration' do
            expect{
              post animals_path, params: @params
            }.to change(Registration.all, :count)
          end
          it 'should cerate a registration on the animal' do
            post animals_path, params: @params
            expect(Animal.last.registrations.count).to eq 1
          end
        end
      end
      context 'invalid params' do
        before do
          @params = {animal: FactoryBot.attributes_for(:animal, owner_id: @animal.owner_id, breed_id: @animal.breed_id, name: '')}
          #TODO test without/with invalid owner/breed
        end
        it 'should return http 200' do
          post animals_path, params: @params
          expect(response).to have_http_status 200
        end
        it 'should not create new animal' do
          expect{
            post animals_path, params: @params
          }.to_not change(Animal.all, :count)
        end
        context 'with invalid (female) sire' do
          before do
            @sire = FactoryBot.create(:animal, is_male: false)
            @params = {animal: FactoryBot.attributes_for(:animal, owner_id: @animal.owner_id, breed_id: @animal.breed_id, sire_id: @sire.id)}
          end
          it 'should return http 200' do
            post animals_path, params: @params
            expect(response).to have_http_status 200
          end
          it 'should not create new animal' do
            expect{
              post animals_path, params: @params
            }.to_not change(Animal.all, :count)
          end
        end
        context 'with invalid (male) dam' do
          before do
            @dam = FactoryBot.create(:animal, is_male: true)
            @params = {animal: FactoryBot.attributes_for(:animal, owner_id: @animal.owner_id, breed_id: @animal.breed_id, dam_id: @dam.id)}
          end
          it 'should return http 200' do
            post animals_path, params: @params
            expect(response).to have_http_status 200
          end
          it 'should not create new animal' do
            expect{
              post animals_path, params: @params
            }.to_not change(Animal.all, :count)
          end
        end
      end
    end
    describe 'update' do
      context 'valid params' do
        before do
          @params = {animal: FactoryBot.attributes_for(:animal, owner_id: @animal.owner_id, breed_id: @animal.breed_id)}
        end
        it 'should redirect to the animal' do
          put animal_path(@animal), params: @params
          expect(response).to redirect_to animal_path(@animal)
        end
        it 'should update the animal' do
          expect{
            put animal_path(@animal), params: @params
          }.to change{
            @animal.reload
            @animal.name
          }
        end
        context 'with sire' do
          it 'should update with no sire' do
            @params[:animal][:sire_id] = ""
            put animal_path(@animal), params: @params
            @animal.reload
            expect(@animal.sire).to be_nil
          end
          it 'should change to new sire' do
            @sire = FactoryBot.create(:animal, is_male: true)
            @params[:animal][:sire_id] = "#{@sire.id}"
            put animal_path(@animal), params: @params
            @animal.reload
            expect(@animal.sire).to eq @sire
          end
        end
        context 'with dam' do
          it 'should update with no dam' do
            @params[:animal][:dam_id] = ""
            put animal_path(@animal), params: @params
            @animal.reload
            expect(@animal.dam).to be_nil
          end
          it 'should change to new dam' do
            @dam = FactoryBot.create(:animal, is_male: false)
            @params[:animal][:dam_id] = "#{@dam.id}"
            put animal_path(@animal), params: @params
            @animal.reload
            expect(@animal.dam).to eq @dam
          end
        end
        context 'adding registrations' do
          before do
            @breed = @animal.breed
            @reg = FactoryBot.create(:registrar, breed: @breed)
            @params[:registrations] = {@reg.name.parameterize => FactoryBot.attributes_for(:registration)}
          end
          it 'should redirect to the animal' do
            put animal_path(@animal), params: @params
            expect(response).to redirect_to animal_path(@animal)
          end
          it 'should create registration' do
            expect{
              put animal_path(@animal), params: @params
            }.to change(Registration.all, :count)
          end
          it 'should add registration to animal' do
            expect{
              put animal_path(@animal), params: @params
            }.to change(@animal.registrations, :count)
          end
        end
        context 'editing registrations' do
          before do
            @breed = @animal.breed
            @reg = FactoryBot.create(:registrar, breed: @breed)
            @registration = FactoryBot.create(:registration, registrar: @reg, animal: @animal)
            @params[:registrations] = {@reg.name.parameterize => FactoryBot.attributes_for(:registration)}
          end
          it 'should redirect to animal' do
            put animal_path(@animal), params: @params
            expect(response).to redirect_to animal_path(@animal)
          end
          it 'should update registration' do
            expect{
              put animal_path(@animal), params: @params
            }.to change{
              @registration.reload
              @registration.registration
            }
          end
        end
        context 'delete registrations' do
          before do
            @reg = FactoryBot.create(:registrar, breed: @animal.breed)
            @registration = FactoryBot.create(:registration, registrar: @reg, animal: @animal)
            @params[:registrations] = {@reg.name.parameterize => FactoryBot.attributes_for(:registration, registration: '', ai_certification: '')}
          end
          it 'should redirect to animal' do
            put animal_path(@animal), params: @params
            expect(response).to redirect_to animal_path(@animal)
          end
          it 'remove the registration' do
            expect{
              put animal_path(@animal), params: @params
            }.to change(Registration.all, :count).by(-1)
          end
        end
      end
      context 'invalid params' do
        before do
          @params = {animal: FactoryBot.attributes_for(:animal, owner_id: @animal.owner_id, breed_id: @animal.breed_id, name: '')}
          #TODO test without/with invalid owner/breed
        end
        it 'should return http 200' do
          put animal_path(@animal), params: @params
          expect(response).to have_http_status 200
        end
        it 'should not update the animal' do
          expect{
            put animal_path(@animal), params: @params
          }.to_not change{
            @animal.reload
            @animal.name
          }
        end
        context 'with invalid (female) sire' do
          before do
            @sire = FactoryBot.create(:animal, is_male: false)
            @params = {animal: FactoryBot.attributes_for(:animal, owner_id: @animal.owner_id, breed_id: @animal.breed_id, sire_id: @sire.id)}
          end
          it 'should return http 200' do
            put animal_path(@animal), params: @params
            expect(response).to have_http_status 200
          end
          it 'should not update the animal' do
            expect{
              put animal_path(@animal), params: @params
            }.to_not change{
              @animal.reload
              @animal.sire
            }
          end
        end
        context 'with invalid (male) dam' do
          before do
            @dam = FactoryBot.create(:animal, is_male: true)
            @params = {animal: FactoryBot.attributes_for(:animal, owner_id: @animal.owner_id, breed_id: @animal.breed_id, dam_id: @dam.id)}
          end
          it 'should return http 200' do
            put animal_path(@animal), params: @params
            expect(response).to have_http_status 200
          end
          it 'should not update the animal' do
            expect{
              put animal_path(@animal), params: @params
            }.to_not change{
              @animal.reload
              @animal.dam
            }
          end
        end
      end
    end
    describe 'delete' do
      it 'should redirect to index' do
        delete animal_path(@animal)
        expect(response).to redirect_to animals_path
      end
      it 'should delete animal' do
        expect{
          delete animal_path(@animal)
        }.to change(Animal.all, :count)
      end
    end
  end
end
