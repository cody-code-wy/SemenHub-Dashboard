require 'rails_helper'

RSpec.describe "LineItems", type: :request do
  context 'Logged Out' do
    before do
      @line_item = FactoryBot.create(:line_item)
      @purchase = @line_item.purchase
    end
    describe 'new' do
      it 'should redirect to /login' do
        get new_purchase_line_item_path(@purchase)
        expect(request).to redirect_to '/login'
      end
    end
    describe 'edit' do
      it 'should redirect to /login' do
        get edit_purchase_line_item_path(@purchase, @line_item)
        expect(request).to redirect_to '/login'
      end
    end
    describe 'create' do
      before do
        @params = {line_item: FactoryBot.attributes_for(:line_item)}
      end
      it 'should redirect to /login' do
        post purchase_line_items_path(@purchase), params: @params
        expect(request).to redirect_to '/login'
      end
      it 'should not create a new line item' do
        expect{
          post purchase_line_items_path(@purchase), params: @params
        }.to_not change(LineItem.all, :count)
      end
    end
    describe 'update' do
      before do
        @params = {line_item: FactoryBot.attributes_for(:line_item)}
      end
      it 'should redirect to /login' do
        put purchase_line_item_path(@purchase, @line_item), params: @params
        expect(response).to redirect_to '/login'
      end
      it 'should not change the line item' do
        expect{
          put purchase_line_item_path(@purchase, @line_item), params: @params
        }.to_not change{
          @line_item.reload
          @line_item.name
        }
      end
    end
    describe 'destroy' do
      it 'should redirect to /login' do
        delete purchase_line_item_path(@purchase, @line_item)
        expect(response).to redirect_to '/login'
      end
      it 'should not delete the line item' do
        expect{
          delete purchase_line_item_path(@purchase, @line_item)
        }.to_not change(LineItem.all, :count)
      end
    end
  end
  context 'Logged In' do
    before do
      post '/login', params: {email: 'test@test.com', password: 'password'}
      @line_item = FactoryBot.create(:line_item)
      @purchase = @line_item.purchase
    end
    describe 'new' do
      it 'should be success' do
        get new_purchase_line_item_path(@purchase)
        expect(response).to be_success
      end
    end
    describe 'edit' do
      it 'should be success' do
        get edit_purchase_line_item_path(@purchase, @line_item)
        expect(response).to be_success
      end
    end
    describe 'create' do
      context 'valid parameters' do
        before do
          @params = {line_item: FactoryBot.attributes_for(:line_item)}
        end
        it 'should redirect to the purchase' do
          post purchase_line_items_path(@purchase), params: @params
          expect(response).to redirect_to purchase_path(@purchase)
        end
        it 'should create new line item' do
          expect{
            post purchase_line_items_path(@purchase), params: @params
          }.to change(LineItem.all, :count)
        end
      end
      context 'invalid parameters' do
        before do
          @params = {line_item: FactoryBot.attributes_for(:line_item, name: '')}
        end
        it 'should return http 200' do
          post purchase_line_items_path(@purchase), params: @params
          expect(response).to have_http_status 200
        end
        it 'should not create new line item' do
          expect{
            post purchase_line_items_path(@purchase), params: @params
          }.to_not change(LineItem.all, :count)
        end
      end
    end
    describe 'update' do
      context 'valid parameters' do
        before do
          @params = {line_item: FactoryBot.attributes_for(:line_item)}
        end
        it 'should redirect to purchase' do
          put purchase_line_item_path(@purchase, @line_item), params: @params
          expect(response).to redirect_to purchase_path(@purchase)
        end
        it 'should update line item' do
          expect{
            put purchase_line_item_path(@purchase, @line_item), params: @params
          }.to change{
            @line_item.reload
            @line_item.name
          }
        end
      end
      context 'invalid parameters' do
        before do
          @params = {line_item: FactoryBot.attributes_for(:line_item, name: '')}
        end
        it 'should return http 200' do
          put purchase_line_item_path(@purchase, @line_item), params: @params
          expect(response).to have_http_status 200
        end
        it' should not update line item' do
          expect{
            put purchase_line_item_path(@purchase, @line_item), params: @params
          }.to_not change{
            @line_item.reload
            @line_item.name
          }
        end
      end
    end
    describe 'destroy' do
      it 'should redirect to purchase' do
        delete purchase_line_item_path(@purchase, @line_item), params: @params
        expect(response).to redirect_to purchase_path(@purchase)
      end
      it 'should destoy line_item' do
        expect{
          delete purchase_line_item_path(@purchase, @line_item), params: @params
        }.to change(LineItem.all, :count)
      end
    end
  end
end
