require 'rails_helper'

RSpec.describe 'Settings', type: :request do
  before do
    post '/login', params: {email: 'test@test.com', password: 'password'}
  end
  describe 'GET /settings' do
    it 'Returns success' do
      get settings_path
      expect(response).to have_http_status(200)
    end
  end
  describe 'POST /settings' do
    before do
      @params = { settings: {} }
      Setting.settings.keys.each do |key|
        @params[:settings][key] = {value: 'false'}
      end
    end
    it 'Returns https redirect status 302' do
      post settings_path, params: @params
      expect(response).to have_http_status(302)
    end
    it 'Should redirect to settings_path' do
      post settings_path, params: @params
      expect(response).to redirect_to(Setting)
    end
    it 'Shourd create missing settings' do
      Setting.all.destroy_all
      expect {
        post settings_path, params: @params
      }.to change(Setting, :count)
    end
    it 'Should change the settings(s)' do
      Setting.settings.keys.each do |setting|
        Setting.create(setting: setting, value: 'true')
      end
      expect {
        post settings_path, params: @params
      }.to change {
        Setting.all.first.value
      }
    end
  end
end
