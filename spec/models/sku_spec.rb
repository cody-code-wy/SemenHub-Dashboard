require 'rails_helper'

RSpec.describe Sku, type: :model do
  describe 'Factory' do
    it 'should have a valid factory' do
      expect(FactoryBot.build(:sku)).to be_valid
    end
  end
  describe 'Validations' do
    it 'should be valid without private' do
      expect(FactoryBot.build(:sku, private: nil)).to be_valid
    end
    it 'should be invalid without semen_type' do
      expect(FactoryBot.build(:sku, semen_type: nil)).to_not be_valid
    end
    it 'should be invalid without price_per_unit' do
      expect(FactoryBot.build(:sku, price_per_unit: nil)).to_not be_valid
    end
    it 'should be invalid witohut semen_count' do
      expect(FactoryBot.build(:sku, semen_count: nil)).to_not be_valid
    end
    it 'should be invalid without animal' do
      expect(FactoryBot.build(:sku, animal: nil)).to_not be_valid
    end
    it 'should be invalid without storageFacility' do
      expect(FactoryBot.build(:sku, storagefacility: nil)).to_not be_valid
    end
    it 'should be invalid without seller' do
      expect(FactoryBot.build(:sku, seller: nil)).to_not be_valid
    end
    it 'should be valid without cost_per_unit' do
      expect(FactoryBot.build(:sku, cost_per_unit: nil)).to be_valid
    end
    it 'should be valid without cane_code' do
      expect(FactoryBot.build(:sku, cane_code: nil)).to be_valid
    end
    it 'should be valid without has_percent' do
      expect(FactoryBot.build(:sku, has_percent: nil)).to be_valid
    end
  end
  describe 'Relation' do
    before do
      @sku = FactoryBot.build(:sku, :with_inventory_transactions)
    end
    it 'should have an animal' do
      expect(@sku.animal).to be_an Animal
    end
    it 'should have a storageFacility'  do
      expect(@sku.storagefacility).to be_a StorageFacility
    end
    it 'should have a user as seller' do
      expect(@sku.seller).to be_a User
    end
    it 'should have many inventory_transactions' do
      expect(@sku.inventory_transaction.first).to be_an InventoryTransaction
    end
  end
  describe 'Methods' do
    context 'similar' do
      before do
        @sku_a = FactoryBot.create(:sku, :with_inventory_transactions)
        @sku_b = FactoryBot.create(:sku, :with_inventory_transactions) #will be different
        @sku = FactoryBot.build(:sku,
                                :with_inventory_transactions,
                                private: @sku_a.private,
                                semen_type: @sku_a.semen_type,
                                price_per_unit: @sku_a.price_per_unit,
                                semen_count: @sku_a.semen_count,
                                animal: @sku_a.animal,
                                storagefacility: @sku_a.storagefacility
                               )
      end
      it 'should return Skus' do
        expect(@sku.similar.first).to be_a Sku
      end
      describe 'matching all params except id, seller, cost_per_unit, cane_code, and has_percent' do
        it 'should be in output' do
          expect(@sku.similar).to include @sku_a
        end
      end
      describe 'not matching params' do
        it 'should not be output' do
          expect(@sku.similar).to_not include @sku_b
        end
      end
    end
    context 'quantity' do
      it 'should return the appropiate quantity' do
        @sku = FactoryBot.create(:sku)
        @transactions = FactoryBot.create_list(:inventory_transaction, 2, quantity: 2, sku: @sku)
        expect(@sku.quantity).to eq 4
      end
    end
    context 'get_commission' do
      describe 'when cost_per_unit = nil' do
        before do
          @sku = FactoryBot.build(:sku)
        end
        it 'should return seller\' commission percent' do
          expect(@sku.get_commission).to eq @sku.seller.commission.commission_percent
        end
      end
      describe 'when cost_per_unit set' do
        before do
          @sku = FactoryBot.build(:sku, price_per_unit: 100, cost_per_unit: 90)
        end
        it 'should return a valid computed number' do
          expect(@sku.get_commission).to eq 10
        end
      end
    end
    context 'get_cost_per_unit' do
      describe 'when cost_per_unit = nil' do
        before do
          @commission = FactoryBot.build(:commission, commission_percent: 10)
          @seller = FactoryBot.build(:user, commission: @commission)
          @sku = FactoryBot.build(:sku, price_per_unit: 100, seller: @seller)
        end
        it 'should return a valid coputed number' do
          expect(@sku.get_cost_per_unit).to eq 90
        end
      end
      describe 'when cost_per_unit set' do
        before do
          @sku = FactoryBot.build(:sku, cost_per_unit: 90)
        end
        it 'should return cost_per_unit' do
          expect(@sku.get_cost_per_unit).to eq 90
        end
      end
    end
  end
end
