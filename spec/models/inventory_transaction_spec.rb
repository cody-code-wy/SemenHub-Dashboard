require 'rails_helper'

RSpec.describe InventoryTransaction, type: :model do
  it 'should have a valid factory' do
    expect(FactoryBot.build(:inventory_transaction)).to be_valid
  end
  describe 'Validations' do
    it 'should be invalid without quantity' do
      expect(FactoryBot.build(:inventory_transaction,  quantity: nil)).to_not be_valid
    end
    it 'should be invalid without sku' do
      expect(FactoryBot.build(:inventory_transaction, sku: nil)).to_not be_valid
    end
  end
  describe 'Relations' do
    before do
      @it = FactoryBot.build(:inventory_transaction, :with_purchases)
    end
    it 'should have a SKU' do
      expect(@it.sku).to be_a Sku
    end
    it 'should have many purchase_transactions' do
      expect(@it.purchase_transactions.first).to be_a PurchaseTransaction
    end
    it 'should have many purchase thru purchase_transactions' do
      expect(@it.purchases.first).to be_a Purchase
    end
  end
end
