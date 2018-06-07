require 'rails_helper'

RSpec.describe "Images", type: :request do
  context 'Logged Out' do
    before do
      @animal = FactoryBot.create(:animal)
      @image = FactoryBot.create(:image, animal: @animal)
    end
    describe 'new' do
      it 'should redirect to /login' do
        get new_animal_image_path(@animal, @image)
        expect(response).to redirect_to '/login'
      end
    end
    describe 'create' do
      before do
        @params = { image: FactoryBot.attributes_for(:image, animal: @animal) }
      end
      it 'should redirect to /login' do
        post animal_images_path(@animal), params: @params
        expect(response).to redirect_to '/login'
      end
      it 'should not create an image' do
        expect{
          post animal_images_path(@animal), params: @params
        }.to_not change(Image, :count)
      end
    end
    describe 'destroy' do
      it 'should redirect to /login' do
        delete animal_image_path(@animal, @image)
        expect(response).to redirect_to '/login'
      end
      it 'should not destroy an image' do
        expect{
          delete animal_image_path(@animal, @image)
        }.to_not change(Image, :count)
      end
    end
  end

  context 'Logged In' do
    before do
      post '/login', params: {email: 'admin@test.com', password: 'password'}
      @animal = FactoryBot.create(:animal)
      @image = FactoryBot.create(:image, animal: @animal)
    end
    describe 'new' do
      it 'should be successfull' do
        get new_animal_image_path(@animal)
        expect(response).to be_success
      end
    end
    describe 'create' do
      context 'image upload to s3' do
        before do
          @params = { image: { s3_object: "#{@animal.id}:test.png" } }
        end
        describe 'with valid parameters' do
          it 'should redirect to animal' do
            post animal_images_path(@animal), params: @params
            expect(response).to redirect_to animal_path(@animal)
          end
          it 'should have s3_object set on image' do
            post animal_images_path(@animal), params: @params
            expect(Image.last.s3_object).to be_truthy
          end
          it 'should create an image' do
            expect{
              post animal_images_path(@animal), params: @params
            }.to change(Image,:count).by(1)
          end
        end
        describe 'with invalid parameters' do
          before do
            @params = { image: { s3_object: 'Invalid Formatted S3_object!!!' } }
          end
          it 'should redirect to animal' do
            post animal_images_path(@animal), params: @params
            expect(response).to redirect_to animal_path(@animal)
          end
          it 'should set flash[:notice]' do
            post animal_images_path(@animal), params: @params
            expect(flash[:notice]).to be_truthy
          end
          it 'should not create an image' do
            expect{
              post animal_images_path(@animal), params: @params
            }.to_not change(Image,:count)
          end
        end
      end
      context 'image url' do
        before do
          @params = { image: FactoryBot.attributes_for(:image, animal: @animal) }
        end
        describe 'with valid parameters' do
          it 'should redirect to animal' do
            post animal_images_path(@animal), params: @params
            expect(response).to redirect_to animal_path(@animal)
          end
          it 'should create an image' do
            expect{
              post animal_images_path(@animal), params: @params
            }.to change(Image,:count).by(1)
          end
          it 'sholud not have s3_object set on image' do
            post animal_images_path(@animal), params: @params
            expect(Image.last.s3_object).to be_falsy
          end
        end
        describe 'with invalid parameters' do
          before do
            @params = { image: FactoryBot.attributes_for(:image, animal: @animal, url_format: "")}
          end
          it 'should redirect to animal' do
            post animal_images_path(@animal), params: @params
            expect(response).to redirect_to animal_path(@animal)
          end
          it 'should set flash[:notice]' do
            post animal_images_path(@animal), params: @params
            expect(flash[:notice]).to be_truthy
          end
          it 'should not create an image' do
            expect{
              post animal_images_path(@animal), params: @params
            }.to_not change(Image,:count)
          end
        end
      end
    end
    describe 'destroy' do
      it 'should redirect to animal' do
        delete animal_image_path(@animal, @image)
        expect(response).to redirect_to animal_path(@animal)
      end
      it 'should destroy image' do
        expect{
          delete animal_image_path(@animal, @image)
        }.to change(Image, :count).by(-1)
      end
    end
  end
end
