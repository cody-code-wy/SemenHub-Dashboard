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
  describe 'url function' do
    before do
      @image = FactoryBot.build(:image, url_format: "%dx300")
    end
    it 'should return url_format formatted with 250 with no params' do
      expect(@image.url).to eq "250x300"
    end
    it 'sohuld return url_format formatter with first param' do
      expect(@image.url(300)).to eq "300x300"
    end
  end
end
