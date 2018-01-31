require 'rails_helper'

RSpec.describe PurchaseTransaction, type: :model do
  it 'should have a valid factory' do
    expect(FactoryBot.build(:purchase_transaction)).to be_valid
  end
  describe 'Validations' do
    it 'should be invalid without a purchase' do
      expect(FactoryBot.build(:purchase_transaction, purchase: nil)).to_not be_valid
    end
    it 'should be invalid without a inventory_transaction' do
      expect(FactoryBot.build(:purchase_transaction, inventory_transaction: nil)).to_not be_valid
    end
  end

  describe 'Relations' do
    before do
      @pt = FactoryBot.build(:purchase_transaction)
    end
    it 'should have a purchase' do
      expect(@pt.purchase).to be_a Purchase
    end
    it 'should have an inventory_transaction' do
      expect(@pt.inventory_transaction).to be_an InventoryTransaction
    end
  end
end
