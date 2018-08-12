require 'rails_helper'

RSpec.feature "UpdateCarts", type: :feature, js: true do
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
  it 'should update the quantity on the backend' do
    visit '/login'
    within 'form' do
      fill_in('email', with: 'admin@test.com')
      fill_in('password', with: 'password')
      click_on('Login')
    end
    visit skus_path
    @sku_1_quantity = '5'
    @sku_2_quantity = '30'
    fill_in("#{@sku.id}_quantity", with: @sku_1_quantity)
    click_on("Add sku##{@sku.id} to Cart")
    expect(accept_alert).to eq('Added to cart')
    fill_in("#{@sku2.id}_quantity", with: @sku_2_quantity)
    click_on("Add sku##{@sku2.id} to Cart")
    expect(accept_alert).to eq('Added to cart')
    visit cart_path
    expect(page).to have_content "#{@sku.id}"
    expect(page).to have_field("quantity_sku_#{@sku.id}")
    expect(find_by_id("quantity_sku_#{@sku.id}").value).to eq @sku_1_quantity
    expect(page).to have_content "#{@sku2.id}"
    expect(page).to have_field("quantity_sku_#{@sku2.id}")
    expect(find_by_id("quantity_sku_#{@sku2.id}").value).to eq @sku_2_quantity
    @sku_1_new_quantity = '8'
    @sku_2_new_quantity = '10'
    fill_in("quantity_sku_#{@sku.id}", with: @sku_1_new_quantity)
    fill_in("quantity_sku_#{@sku2.id}", with: @sku_2_new_quantity)
    click_on('Update Cart')
    wait_for_ajax
    visit current_path
    expect(find_by_id("quantity_sku_#{@sku.id}").value).to eq @sku_1_new_quantity
    expect(find_by_id("quantity_sku_#{@sku2.id}").value).to eq @sku_2_new_quantity
    expect($redis.get("QUANTITY-#{@user.id}.#{@user.cart}-#{@sku.id}")).to eq @sku_1_new_quantity
    expect($redis.get("QUANTITY-#{@user.id}.#{@user.cart}-#{@sku2.id}")).to eq @sku_2_new_quantity
  end
  it 'should update the quantity on page to sku.quantity if set to more than sku.quantity' do
    visit '/login'
    within 'form' do
      fill_in('email', with: 'admin@test.com')
      fill_in('password', with: 'password')
      click_on('Login')
    end
    visit skus_path
    @sku_1_quantity = '5'
    @sku_2_quantity = '30'
    fill_in("#{@sku.id}_quantity", with: @sku_1_quantity)
    click_on("Add sku##{@sku.id} to Cart")
    expect(accept_alert).to eq('Added to cart')
    fill_in("#{@sku2.id}_quantity", with: @sku_2_quantity)
    click_on("Add sku##{@sku2.id} to Cart")
    expect(accept_alert).to eq('Added to cart')
    visit cart_path
    expect(page).to have_content "#{@sku.id}"
    expect(page).to have_field("quantity_sku_#{@sku.id}")
    expect(find_by_id("quantity_sku_#{@sku.id}").value).to eq @sku_1_quantity
    expect(page).to have_content "#{@sku2.id}"
    expect(page).to have_field("quantity_sku_#{@sku2.id}")
    expect(find_by_id("quantity_sku_#{@sku2.id}").value).to eq @sku_2_quantity
    @sku_1_new_quantity = "#{@sku.quantity + 100}"
    @sku_2_new_quantity = "#{@sku2.quantity + 100}"
    fill_in("quantity_sku_#{@sku.id}", with: @sku_1_new_quantity)
    fill_in("quantity_sku_#{@sku2.id}", with: @sku_2_new_quantity)
    click_on('Update Cart')
    wait_for_ajax
    expect(find_by_id("quantity_sku_#{@sku.id}").value).to eq "#{@sku.quantity}"
    expect(find_by_id("quantity_sku_#{@sku2.id}").value).to eq "#{@sku2.quantity}"
    expect($redis.get("QUANTITY-#{@user.id}.#{@user.cart}-#{@sku.id}")).to eq "#{@sku.quantity}"
    expect($redis.get("QUANTITY-#{@user.id}.#{@user.cart}-#{@sku2.id}")).to eq "#{@sku2.quantity}"
  end
  it 'should remove any rows with the quantity set to 0' do
    visit '/login'
    within 'form' do
      fill_in('email', with: 'admin@test.com')
      fill_in('password', with: 'password')
      click_on('Login')
    end
    visit skus_path
    @sku_1_quantity = '5'
    @sku_2_quantity = '30'
    fill_in("#{@sku.id}_quantity", with: @sku_1_quantity)
    click_on("Add sku##{@sku.id} to Cart")
    expect(accept_alert).to eq('Added to cart')
    fill_in("#{@sku2.id}_quantity", with: @sku_2_quantity)
    click_on("Add sku##{@sku2.id} to Cart")
    expect(accept_alert).to eq('Added to cart')
    visit cart_path
    expect(page).to have_content "#{@sku.id}"
    expect(page).to have_field("quantity_sku_#{@sku.id}")
    expect(find_by_id("quantity_sku_#{@sku.id}").value).to eq @sku_1_quantity
    expect(page).to have_content "#{@sku2.id}"
    expect(page).to have_field("quantity_sku_#{@sku2.id}")
    expect(find_by_id("quantity_sku_#{@sku2.id}").value).to eq @sku_2_quantity
    @sku_1_new_quantity = '0'
    fill_in("quantity_sku_#{@sku.id}", with: @sku_1_new_quantity)
    click_on('Update Cart')
    wait_for_ajax
    expect(page).to have_no_field("quantity_sku_#{@sku.id}")
    within 'tbody' do
      expect(page).to have_selector 'tr', count: 1
    end
  end
end
