require 'rails_helper'

RSpec.describe "Applications", type: :request do
  describe 'update_pass' do
    before do
      @user = User.find_by_email('admin@test.com')
      @user.update(temp_pass: true)
      post '/login', params: {email: 'admin@test.com', password: 'password'}
    end
    it 'should redirect to /user/:id/password' do
      get '/'
      expect(response).to redirect_to user_path(@user)+'/password'
    end
    it 'should be success going to /user/:id/password' do
      get user_path(@user)+'/password'
      expect(response).to be_success
    end
    it 'should be success posting to /user/:id/password' do
      patch user_path(@user)+'/password', params: {user: {password: 'password2', password_confirmation: 'password2'}}
      expect(response).to redirect_to user_path(@user)
    end
  end
end
