require 'rails_helper'

RSpec.describe "StorageFacilities", type: :request do
  before do
    @facility = FactoryBot.create(:storage_facility)
    @params = {storage_facility: FactoryBot.attributes_for(:storage_facility)}
    @params[:storage_facility][:mailing_address] = FactoryBot.attributes_for(:address)
  end
  context 'logged out' do
    describe 'index' do
      it 'should redirect to /login' do
        get storage_facilities_path
        expect(response).to redirect_to '/login'
      end
    end
    describe 'show' do
      it 'should redirect to /login' do
        get storage_facility_path(@facility)
        expect(response).to redirect_to '/login'
      end
    end
    describe 'new' do
      it 'should redirect to /login' do
        get new_storage_facility_path
        expect(response).to redirect_to '/login'
      end
    end
    describe 'create' do
      it 'should redirect to /login' do
        post storage_facilities_path, params: @params
        expect(response).to redirect_to '/login'
      end
      it 'should not create a storage facility' do
        expect{
          post storage_facilities_path, params: @params
        }.to_not change(StorageFacility.all, :count)
      end
    end
    describe 'edit' do
      it 'should redirect to /login' do
        get edit_storage_facility_path(@facility)
        expect(response).to redirect_to '/login'
      end
    end
    describe 'update' do
      it 'should redirect to /login' do
        put storage_facility_path(@facility)
        expect(response).to redirect_to '/login'
      end
      it 'should not update the storage facility' do
        expect {
          put storage_facility_path(@facility)
        }.to_not change{
          @facility.reload
          @facility.name
        }
      end
    end
    describe 'test' do
      before do
        @params = {dest: FactoryBot.create(:storage_facility)}
      end
      it 'should redirect to /login' do
        get storage_facility_test_path(@facility), params: @params
        expect(response).to redirect_to '/login'
      end
      it 'should not call get_shipping_price on facility' do
        expect(@facility).to_not receive(:get_shipping_price)
        get storage_facility_test_path(@facility), params: @params
      end
    end
  end
  context 'logged in' do
    before do
      post '/login', params: {email: 'test@test.com', password: 'password'}
    end
    describe 'index' do
      it 'should be success' do
        get storage_facilities_path
        expect(response).to be_success
      end
    end
    describe 'show' do
      it 'should be success' do
        get storage_facility_path(@facility)
        expect(response).to be_success
      end
    end
    describe 'new' do
      it 'should be success' do
        get new_storage_facility_path
        expect(response).to be_success
      end
    end
    describe 'create' do
      context 'valid params' do
        it 'should redirect to new facility' do
          post storage_facilities_path, params: @params
          expect(response).to redirect_to StorageFacility.last
        end
        it 'should create facility' do
          expect{
            post storage_facilities_path, params: @params
          }.to change(StorageFacility.all, :count)
        end
        it 'should create new address' do
          expect{
            post storage_facilities_path, params: @params
          }.to change(Address.all, :count)
        end
        it 'should have correct address on facility' do
          post storage_facilities_path, params: @params
          expect(StorageFacility.last.address).to eq Address.last
        end
      end
      context 'invalid facility params' do
        before do
          @params[:storage_facility][:name] = nil
        end
        it 'should return http 200 status' do
          post storage_facilities_path, params: @params
          expect(response).to have_http_status 200
        end
        it 'should not create storage facility' do
          expect{
            post storage_facilities_path, params: @params
          }.to_not change(StorageFacility.all, :count)
        end
        it 'should not create address' do
          expect{
            post storage_facilities_path, params: @params
          }.to_not change(Address.all, :count)
        end
      end
      context 'invalid address params' do
        before do
          @params[:storage_facility][:mailing_address][:line1] = nil
        end
        it 'should return http 200 status' do
          post storage_facilities_path, params: @params
          expect(response).to have_http_status 200
        end
        it 'should not create storage facility' do
          expect{
            post storage_facilities_path, params: @params
          }.to_not change(StorageFacility.all, :count)
        end
        it 'should not create address' do
          expect{
            post storage_facilities_path, params: @params
          }.to_not change(Address.all, :count)
        end
      end
      context 'invalid all params' do
        before do
          @params[:storage_facility][:name] = nil
          @params[:storage_facility][:mailing_address][:line1] = nil
        end
        it 'should return http 200 status' do
          post storage_facilities_path, params: @params
          expect(response).to have_http_status 200
        end
        it 'should not create storage facility' do
          expect{
            post storage_facilities_path, params: @params
          }.to_not change(StorageFacility.all, :count)
        end
        it 'should not create address' do
          expect{
            post storage_facilities_path, params: @params
          }.to_not change(Address.all, :count)
        end
      end
    end
    describe 'edit' do
      it 'should be success' do
        get edit_storage_facility_path(@facility)
        expect(response).to be_success
      end
    end
    describe 'update' do
      context 'valid params' do
        it 'should redirect to facility' do
          put storage_facility_path(@facility), params: @params
          expect(response).to redirect_to storage_facility_path(@facility)
        end
        it 'should update facility' do
          expect{
            put storage_facility_path(@facility), params: @params
          }.to change{
            @facility.reload
            @facility.name
          }
        end
        it 'should update address' do
          expect{
            put storage_facility_path(@facility), params: @params
          }.to change{
            @facility.address.reload
            @facility.address.line1
          }
        end
        it 'should not create address' do
          expect{
            put storage_facility_path(@facility), params: @params
          }.to_not change(Address.all, :count)
        end
        it 'should have correct address on facility' do
          @old_addr_id = @facility.address.id
          put storage_facility_path(@facility), params: @params
          expect(@facility.address_id).to eq @old_addr_id
        end
      end
      context 'invalid facility params' do
        before do
          @params[:storage_facility][:name] = nil
        end
        it 'should return http 200 status' do
          put storage_facility_path(@facility), params: @params
          expect(response).to have_http_status 200
        end
        it 'should not update storage facility' do
          expect{
            put storage_facility_path(@facility), params: @params
          }.to_not change{
            @facility.reload
            @facility.name
          }
        end
        it 'should not update address' do
          expect{
            put storage_facility_path(@facility), params: @params
          }.to_not change{
            @facility.address.reload
            @facility.address.line1
          }
        end
      end
      context 'invalid address params' do
        before do
          @params[:storage_facility][:mailing_address][:line1] = nil
        end
        it 'should return http 200 status' do
          put storage_facility_path(@facility), params: @params
          expect(response).to have_http_status 200
        end
        it 'should not update storage facility' do
          expect{
            put storage_facility_path(@facility), params: @params
          }.to_not change{
            @facility.reload
            @facility.name
          }
        end
        it 'should not update address' do
          expect{
            put storage_facility_path(@facility), params: @params
          }.to_not change{
            @facility.address.reload
            @facility.address.line1
          }
        end
      end
      context 'invalid all params' do
        before do
          @params[:storage_facility][:name] = nil
          @params[:storage_facility][:mailing_address][:line1] = nil
        end
        it 'should return http 200 status' do
          put storage_facility_path(@facility), params: @params
          expect(response).to have_http_status 200
        end
        it 'should not update storage facility' do
          expect{
            put storage_facility_path(@facility), params: @params
          }.to_not change{
            @facility.reload
            @facility.name
          }
        end
        it 'should not update address' do
          expect{
            put storage_facility_path(@facility), params: @params
          }.to_not change{
            @facility.address.reload
            @facility.address.line1
          }
        end
      end
    end
    describe 'destroy' do
      it 'should redirect to index' do
        delete storage_facility_path(@facility)
        expect(response).to redirect_to storage_facilities_path
      end
      it 'should remove storage facility' do
        expect{
          delete storage_facility_path(@facility)
        }.to change(StorageFacility.all, :count)
      end
    end
    describe 'test' do
      before do
        @dest = FactoryBot.create(:storage_facility)
        @params = {dest: @dest.id}
        allow(@facility).to receive(:get_shipping_price) { {price: 100} }
        allow(StorageFacility).to receive(:find).with(@facility.id.to_s) {@facility}
        allow(StorageFacility).to receive(:find).with(@dest.id.to_s) {@dest}
      end
      it 'should be success' do
        get storage_facility_test_path(@facility), params: @params
        expect(response).to be_success
      end
      it 'should be json' do
        get storage_facility_test_path(@facility), params: @params
        expect(response.header['Content-Type']).to include 'application/json'
      end
      it 'should call get_shipping_price on facility with destination' do
        expect(@facility).to receive(:get_shipping_price).with(100, @dest) { {price: 100} }
        get storage_facility_test_path(@facility), params: @params
      end
    end
  end
end
