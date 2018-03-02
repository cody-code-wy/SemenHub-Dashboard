require 'rails_helper'

RSpec.feature "AnimalShowSkuLinks", type: :feature do
  before do
    visit '/login'
    within 'form' do
      fill_in('email', with: 'test@test.com')
      fill_in('password', with: 'password')
      click_on('Login')
    end
  end
  feature 'Check Sku Link' do
    before do
      @sku = FactoryBot.create(:sku)
      visit animal_path(@sku.animal)
    end
    it 'should go to Sku page' do
      click_on("SKU #{@sku.id}")
      expect(current_path).to eq sku_path(@sku)
    end
  end
end
