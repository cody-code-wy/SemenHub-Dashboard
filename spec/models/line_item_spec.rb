require 'rails_helper'

RSpec.describe LineItem, type: :model do
  describe 'Factory' do
    it 'should have a valid factory' do
      expect(FactoryBot.build(:line_item)).to be_valid
    end
  end

  describe 'Validatios' do
    it 'should be invalid without name' do
      expect(FactoryBot.build(:line_item, name: nil)).to_not be_valid
    end
    it 'should be invalid without value' do
      expect(FactoryBot.build(:line_item, value: nil)).to_not be_valid
    end
    it' should be invalid without purchase' do
      expect(FactoryBot.build(:line_item, purchase: nil)).to_not be_valid
    end
  end

  describe 'Relations' do
    it 'should have a Purchase' do
      expect(FactoryBot.build(:line_item).purchase).to be_a Purchase
    end
    it 'should touch purchase' do
      @line_item = FactoryBot.create(:line_item)
      @purchase = @line_item.purchase
      expect {
        @line_item.touch()
      }.to change{
        @purchase.reload()
        @purchase.updated_at
      }
    end
  end
end
