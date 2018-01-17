require 'rails_helper'

RSpec.describe 'Js', type: :request do
  describe 'Get /js/semenhub.js' do
    it 'Returns Success Response' do
      get '/js/semenhub.js'
      expect(response).to have_http_status(200)
    end
    it 'Should have content type text/javascript' do
      get '/js/semenhub.js'
      expect(response.content_type).to eq "text/javascript"
    end
  end
end
