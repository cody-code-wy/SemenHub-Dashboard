require 'rails_helper'

RSpec.describe "Carts", type: :request do
  describe "Logged Out" do
    before do
      @sku = FactoryBot.create(:sku)
      @params = {skus: {@sku.id => 10}}
    end
    feature "Update" do
      it 'should redirect to /login' do
        post cart_update_path, params: @params
        expect(response).to redirect_to '/login'
      end
    end
    feature "Show" do
      it 'should redirect to /login' do
        get cart_path
        expect(response).to redirect_to '/login'
      end
    end
    feature "Checkout" do
      it 'should redirect to /login' do
        get cart_checkout_path
        expect(response).to redirect_to '/login'
      end
    end
  end
  describe "Logged In" do
    before do
      post '/login', params: {email: 'admin@test.com', password: 'password'}
      @skus = FactoryBot.create_list(:sku, 2, private: false)
      @skus.each do |sku|
        FactoryBot.create(:inventory_transaction, quantity: 100, sku: sku)
      end
      @user = User.find_by_email('admin@test.com')
      @user.cart = SecureRandom.uuid
    end
    feature "Update" do
      before do
        sku_map = {}
        @skus.each do |sku|
          sku_map[sku.id] = 10
        end
        @params = {skus: sku_map}
      end
      it 'should add skus to "CART-#{current_user.id}.#{current_user.cart}" with various user carts' do
        5.times do
          @user.cart = SecureRandom.uuid
          post cart_update_path, params: @params
          expect($redis.smembers("CART-#{@user.id}.#{@user.cart}")).to include "#{@skus.first.id}"
          expect($redis.smembers("CART-#{@user.id}.#{@user.cart}")).to include "#{@skus.last.id}"
        end
      end
      it 'should set ttl on "CART-#{current_user.id}.#{current_user.cart} with various user carts"' do
        5.times do
          @user.cart = SecureRandom.uuid
          post cart_update_path, params: @params
          expect($redis.ttl("CART-#{@user.id}.#{@user.cart}")).to be >= 0
        end
      end
      it 'should set "QUANTITY-#{current_user.id}.#{current_user.cart}-#{sku.id} for each sku with varous user carts"' do
        5.times do
          @user.cart = SecureRandom.uuid
          post cart_update_path, params: @params
          @skus.each do |sku|
            expect($redis.get("QUANTITY-#{@user.id}.#{@user.cart}-#{sku.id}")).to eq '10'
          end
        end
      end
      it 'should set ttl "QUANTITY-#{current_user.id}.#{current_user.cart}-#{sku.id} for each sku with varous user carts"' do
        5.times do
          @user.cart = SecureRandom.uuid
          post cart_update_path, params: @params
          @skus.each do |sku|
            expect($redis.ttl("QUANTITY-#{@user.id}.#{@user.cart}-#{sku.id}")).to be >= 0
          end
        end
      end
      it 'should remove sku from "CART-#{current_user.id}.#{current_user.cart}" if quantity is set to 0' do
        5.times do
          @user.cart = SecureRandom.uuid
          @skus.each do |sku|
            $redis.sadd("CART-#{@user.id}.#{@user.cart}", sku.id)
            $redis.set("QUANTITY-#{@user.id}.#{@user.cart}-#{sku.id}", 10)
            @params[:skus][sku.id] = 0 #set update quantity to 0
          end
          post cart_update_path, params: @params
          @skus.each do |sku|
            expect($redis.smembers("CART-#{@user.id}.#{@user.cart}")).to_not include "#{sku.id}"
          end
        end
      end
        it 'should remove "QUANTITY-#{current_user.id}.#{current_user.cart}-#{sku.id}" if quantity is set to 0' do
        5.times do
          @user.cart = SecureRandom.uuid
          @skus.each do |sku|
            $redis.sadd("CART-#{@user.id}.#{@user.cart}", sku.id)
            $redis.set("QUANTITY-#{@user.id}.#{@user.cart}-#{sku.id}", 10)
            @params[:skus][sku.id] = 0 #set update quantity to 0
          end
          post cart_update_path, params: @params
          @skus.each do |sku|
            expect($redis.get("QUANTITY-#{@user.id}.#{@user.cart}-#{sku.id}")).to be_nil
          end
        end
      end
      it 'should update "CART-#{current_user.id}.#{current_user.cart}" without removing existing skus' do
        5.times do
          @user.cart = SecureRandom.uuid
          @skus.each do |sku|
            $redis.sadd("CART-#{@user.id}.#{@user.cart}", sku.id)
            $redis.set("QUANTITY-#{@user.id}.#{@user.cart}-#{sku.id}", 10)
          end
          @new_sku = FactoryBot.create(:sku, private: false)
          @params[:skus] = {@new_sku.id => "5"}
          post cart_update_path, params: @params
          expect(response).to redirect_to cart_path
          @skus.each do |sku|
            expect($redis.smembers("CART-#{@user.id}.#{@user.cart}")).to include "#{sku.id}"
          end
          expect($redis.smembers("CART-#{@user.id}.#{@user.cart}")).to include "#{@new_sku.id}"
        end
      end
      it 'should reset ttl on "CART-#{current_user.id}.#{current_user.cart}" to $redis_timeout' do
        5.times do
          @user.cart = SecureRandom.uuid
          @skus.each do |sku|
            $redis.sadd("CART-#{@user.id}.#{@user.cart}", sku.id)
          end
          $redis.expire("CART-#{@user.id}.#{@user.cart}", $redis_timeout/10)
          @new_sku = FactoryBot.create(:sku, private: false)
          @params[:skus] = {@new_sku.id => "5"}
          post cart_update_path, params: @params
          expect(response).to redirect_to cart_path
          expect($redis.ttl("CART-#{@user.id}.#{@user.cart}")).to be > $redis_timeout/10
        end
      end
      it 'should redirect to cart_show on text/HTML' do
        post cart_update_path, params: @params
        expect(response).to redirect_to cart_path
      end
      it 'should return mime text/HTML' do
        post cart_update_path, params: @params
        expect(response.header['Content-Type']).to include 'text/html'
      end
      it 'should return http 200 on application/JSON' do
        post cart_update_path, params: @params, headers: {ACCEPT: 'application/json'}
        expect(response).to be_success
      end
      it 'should return mime application/JSON if requested' do
        post cart_update_path, params: @params, headers: {ACCEPT: 'application/json'}
        expect(response.header['Content-Type']).to include 'application/json'
      end
    end
    feature "Show" do
      it 'should return http 200' do
        get cart_path
        expect(response).to be_success
      end
      it 'should return mime text/HTML' do
        get cart_path
        expect(response.header['Content-Type']).to include 'text/html'
      end
      it 'should return http 200 on application/JSON' do
        get cart_path, headers: {ACCEPT: 'application/json'}
        expect(response).to be_success
      end
      it 'should return mime application/JSON if requested' do
        get cart_path, headers: {ACCEPT: 'application/json'}
        expect(response.header['Content-Type']).to include 'application/json'
      end
    end
    feature "Checkout" do
      before do
        @skus.each do |sku|
          $redis.sadd("CART-#{@user.id}.#{@user.cart}", sku.id)
          $redis.set("QUANTITY-#{@user.id}.#{@user.cart}-#{sku.id}", 10)
        end
      end
      describe 'Target user' do
        feature 'No target user' do
          it 'should create a purchase owned by the current_user' do
            expect{
              get cart_checkout_path
            }.to change(Purchase, :count)
            expect(Purchase.last.user.id).to eq @user.id
          end
        end
        feature 'With target user' do
          it 'should create purchase owned by the target user' do
            target_user = FactoryBot.create(:user)
            expect{
              get cart_checkout_path, params: {purchase: {target_user: target_user.id}}
            }.to change(Purchase, :count)
            expect(Purchase.last.user.id).to eq target_user.id
          end
        end
      end
      describe 'InventoryTransactions' do
        it 'should create one InventoryTransaction per sku in cart' do
          expect{
            get cart_checkout_path
          }.to change(InventoryTransaction, :count).by(@skus.count)
        end
        it 'should create InventoryTransactions with appropriate quantites' do
          get cart_checkout_path
          @skus.each do |sku|
            expect(sku.inventory_transaction.last.quantity).to eq(-10)
          end
        end
        it 'should not create InventoryTransactions with more than the quantities available in the sku' do
          @skus.first.inventory_transaction.first.update(quantity: 6)
          get cart_checkout_path
          expect(@skus.first.inventory_transaction.last.quantity).to eq(-6)
        end
      end
      it 'should set user cart to a random UUID' do
        expect(SecureRandom).to receive(:uuid).twice {"random UUID"}
        get cart_checkout_path
        expect(@user.cart).to eq "random UUID"
      end
      it 'redirect to purchase' do
        get cart_checkout_path
        expect(response).to redirect_to purchase_path(Purchase.last)
      end
    end
  end
end
