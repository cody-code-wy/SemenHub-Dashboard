require 'rails_helper'

RSpec.describe Image, type: :model do
  it 'should have a valid factory' do
    expect(FactoryBot.build(:image)).to be_valid
  end
  describe 'validations' do
    it 'should not be valid without url_format' do
      expect(FactoryBot.build(:image, url_format: nil)).to_not be_valid
    end
    it 'should not be vaild without animal' do
      expect(FactoryBot.build(:image, animal: nil)).to_not be_valid
    end
    it 'sholud be valid without s3_object' do
      expect(FactoryBot.build(:image, s3_object: nil)).to be_valid
    end
  end
  describe 'relations' do
    before do
      @image = FactoryBot.build(:image)
    end
    it 'should have an animal of type Animal' do
      expect(@image.animal).to be_an Animal
    end
  end
end
