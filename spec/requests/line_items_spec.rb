require 'rails_helper'

RSpec.describe "LineItems", type: :request do
  context 'Logged Out' do
    before do
      @purchase = FactoryBot.create(:purchase, state: :created)
      @line_item = FactoryBot.create(:line_item, purchase: @purchase)
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
      post '/login', params: {email: 'admin@test.com', password: 'password'}
      @purchase = FactoryBot.create(:purchase, state: :created)
      @line_item = FactoryBot.create(:line_item, purchase: @purchase)
    end
    describe 'new' do
      it 'should be success' do
        get new_purchase_line_item_path(@purchase)
        expect(response).to be_success
      end
      it 'should redirect to purchase if purchase is not mutable' do
        @purchase.invoiced!
        get new_purchase_line_item_path(@purchase)
        expect(response).to redirect_to purchase_path(@purchase)
      end
      it 'should set flash[:alert] if purchase is not mutable' do
        @purchase.invoiced!
        get new_purchase_line_item_path(@purchase)
        expect(flash[:alert]).to be_truthy
      end
    end
    describe 'edit' do
      it 'should be success' do
        get edit_purchase_line_item_path(@purchase, @line_item)
        expect(response).to be_success
      end
      it 'should redirect to purchase if purchase is not mutable' do
        @purchase.invoiced!
        get edit_purchase_line_item_path(@purchase, @line_item)
        expect(response).to redirect_to purchase_path(@purchase)
      end
      it 'should set flash[:alert] if purchase is not mutable' do
        @purchase.invoiced!
        get edit_purchase_line_item_path(@purchase, @line_item)
        expect(flash[:alert]).to be_truthy
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
        it 'should redirect to the purchase if the purchase is not mutable' do
          @purchase.invoiced!
          post purchase_line_items_path(@purchase), params: @params
          expect(response).to redirect_to purchase_path(@purchase)
        end
        it 'should set flash[:alert] if purchase is not mutable' do
          @purchase.invoiced!
          post purchase_line_items_path(@purchase), params: @params
          expect(flash[:alert]).to be_truthy
        end
        it 'should not create a new line item if purchase is not mutable' do
          @purchase.invoiced!
          expect{
            post purchase_line_items_path(@purchase), params: @params
          }.to_not change(LineItem.all, :count)
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
        it 'should redirect to the purchase if the purchase is not mutable' do
          @purchase.invoiced!
          post purchase_line_items_path(@purchase), params: @params
          expect(response).to redirect_to purchase_path(@purchase)
        end
        it 'should set flash[:alert] if purchase is not mutable' do
          @purchase.invoiced!
          post purchase_line_items_path(@purchase), params: @params
          expect(flash[:alert]).to be_truthy
        end
        it 'should not create a new line item if purchase is not mutable' do
          @purchase.invoiced!
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
        it 'should redirect to purchase if purchase is not mutable' do
          @purchase.invoiced!
          put purchase_line_item_path(@purchase, @line_item), params: @params
          expect(response).to redirect_to purchase_path(@purchase)
        end
        it 'should set flash[:alert] if purchase is not mutable' do
          @purchase.invoiced!
          put purchase_line_item_path(@purchase, @line_item), params: @params
          expect(flash[:alert]).to be_truthy
        end
        it 'should not change line item if purchase is not mutable' do
          @purchase.invoiced!
          expect {
            put purchase_line_item_path(@purchase, @line_item) , params: @params
          }.to_not change{
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
        it 'should redirect to purchase if purchase is not mutable' do
          @purchase.invoiced!
          put purchase_line_item_path(@purchase, @line_item), params: @params
          expect(response).to redirect_to purchase_path(@purchase)
        end
        it 'should set flash[:alert] if purchase is not mutable' do
          @purchase.invoiced!
          put purchase_line_item_path(@purchase, @line_item), params: @params
          expect(flash[:alert]).to be_truthy
        end
        it 'should not change line item if purchase is not mutable' do
          @purchase.invoiced!
          expect {
            put purchase_line_item_path(@purchase, @line_item) , params: @params
          }.to_not change{
            @line_item.reload
            @line_item.name
          }
        end
      end
    end
    describe 'destroy' do
      it 'should redirect to purchase' do
        delete purchase_line_item_path(@purchase, @line_item)
        expect(response).to redirect_to purchase_path(@purchase)
      end
      it 'should destoy line_item' do
        expect{
          delete purchase_line_item_path(@purchase, @line_item)
        }.to change(LineItem.all, :count)
      end
      it 'should redirect to purchase if purchase is not mutable' do
        @purchase.invoiced!
        delete purchase_line_item_path(@purchase, @line_item)
        expect(response).to redirect_to purchase_path(@purchase)
      end
      it 'should set flash[:alert] if purchase is not mutable' do
        @purchase.invoiced!
        delete purchase_line_item_path(@purchase, @line_item)
        expect(flash[:alert]).to be_truthy
      end
      it 'should not delete line_item if purchase is not mutable' do
        @purchase.invoiced!
        expect{
          delete purchase_line_item_path(@purchase, @line_item)
        }.to_not change(LineItem.all, :count)
      end
    end
  end
end
