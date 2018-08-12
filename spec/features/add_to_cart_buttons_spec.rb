require 'rails_helper'

RSpec.feature "AddToCartButtons", type: :feature, js: true do
  before :all do
    @user_address = FactoryBot.create(:address)
    @user = FactoryBot.create(:user, mailing_address: @user_address, billing_address: @user_address, payee_address: @user_address)
    @breed = FactoryBot.create(:breed)
    @animal = FactoryBot.create(:animal, breed: @breed, owner: @user)
    @storageFacility = FactoryBot.create(:storage_facility, address: @user_address)
    @sku = FactoryBot.create(:sku, private: false, semen_count: '2.1', storagefacility: @storageFacility, animal: @animal, seller: @user)
    @sku2 = FactoryBot.create(:sku, private: false, semen_count: '5.0', storagefacility: @storageFacility, animal: @animal, seller: @user)
    @it = FactoryBot.create(:inventory_transaction, quantity: 100, sku: @sku)
    @it2 = FactoryBot.create(:inventory_transaction, quantity: 100, sku: @sku2)
  end
  after :all do
    @it.destroy
    @it2.destroy
    @sku.destroy
    @sku2.destroy
    @animal.destroy
    @breed.destroy
    @storageFacility.destroy
    @user.destroy
    @user_address.destroy
  end
  before do
    @user = User.find_by_email('admin@test.com')
    @user.cart = SecureRandom.uuid
  end
  describe 'Animal#Show' do
    feature 'Click add to cart button' do
      it 'should trigger alert window' do
        visit '/login'
        within 'form' do
          fill_in('email', with: 'admin@test.com')
          fill_in('password', with: 'password')
          click_on('Login')
        end
        visit animal_path(@animal)
        click_on("Add sku##{@sku.id} to Cart")
        expect(accept_alert).to eq("Added to cart")
      end
      it 'should show the correct sku# and quantity on cart#show' do
        visit '/login'
        within 'form' do
          fill_in('email', with: 'admin@test.com')
          fill_in('password', with: 'password')
          click_on('Login')
        end
        visit animal_path(@animal)
        @sku_1_quantity = "3"
        @sku_2_quantity = "20"
        fill_in("#{@sku.id}_quantity", with: @sku_1_quantity)
        click_on("Add sku##{@sku.id} to Cart")
        expect(accept_alert).to eq("Added to cart")
        fill_in("#{@sku2.id}_quantity", with: @sku_2_quantity)
        click_on("Add sku##{@sku2.id} to Cart")
        expect(accept_alert).to eq("Added to cart")
        visit cart_path
        expect(page).to have_content "#{@sku.id}"
        expect(page).to have_field("quantity_sku_#{@sku.id}")
        expect(find_by_id("quantity_sku_#{@sku.id}").value).to eq @sku_1_quantity
        expect(page).to have_content "#{@sku2.id}"
        expect(page).to have_field("quantity_sku_#{@sku2.id}")
        expect(find_by_id("quantity_sku_#{@sku2.id}").value).to eq @sku_2_quantity
      end
    end
  end
  describe 'Skus#Index' do
    feature 'Click add to cart button' do
      it 'should trigger alert window' do
        visit '/login'
        within 'form' do
          fill_in('email', with: 'admin@test.com')
          fill_in('password', with: 'password')
          click_on('Login')
        end
        visit skus_path
        click_on("Add sku##{@sku.id} to Cart")
        expect(accept_alert).to eq("Added to cart")
      end
      it 'should show the correct sku# and quantity on cart#show' do
        visit '/login'
        within 'form' do
          fill_in('email', with: 'admin@test.com')
          fill_in('password', with: 'password')
          click_on('Login')
        end
        visit skus_path
        @sku_1_quantity = "3"
        @sku_2_quantity = "20"
        fill_in("#{@sku.id}_quantity", with: @sku_1_quantity)
        click_on("Add sku##{@sku.id} to Cart")
        expect(accept_alert).to eq("Added to cart")
        fill_in("#{@sku2.id}_quantity", with: @sku_2_quantity)
        click_on("Add sku##{@sku2.id} to Cart")
        expect(accept_alert).to eq("Added to cart")
        visit cart_path
        expect(page).to have_content "#{@sku.id}"
        expect(page).to have_field("quantity_sku_#{@sku.id}")
        expect(find_by_id("quantity_sku_#{@sku.id}").value).to eq @sku_1_quantity
        expect(page).to have_content "#{@sku2.id}"
        expect(page).to have_field("quantity_sku_#{@sku2.id}")
        expect(find_by_id("quantity_sku_#{@sku2.id}").value).to eq @sku_2_quantity
      end
    end
  end
  describe 'Skus#Show' do
    feature 'Click add to cart button' do
      it 'should trigger alert window' do
        visit '/login'
        within 'form' do
          fill_in('email', with: 'admin@test.com')
          fill_in('password', with: 'password')
          click_on('Login')
        end
        visit sku_path(@sku)
        click_on("Add to Cart")
        expect(accept_alert).to eq("Added to cart")
      end
      it 'should show the correct sku# and quantity on cart#show' do
        visit '/login'
        within 'form' do
          fill_in('email', with: 'admin@test.com')
          fill_in('password', with: 'password')
          click_on('Login')
        end
        visit sku_path(@sku)
        @sku_1_quantity = "3"
        fill_in("#{@sku.id}_quantity", with: @sku_1_quantity)
        click_on("Add to Cart")
        expect(accept_alert).to eq("Added to cart")
        visit cart_path
        expect(page).to have_content "#{@sku.id}"
        expect(page).to have_field("quantity_sku_#{@sku.id}")
        expect(find_by_id("quantity_sku_#{@sku.id}").value).to eq @sku_1_quantity
      end
    end
  end
end
