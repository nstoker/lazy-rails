# frozen_string_literal: true

require 'rails_helper'

describe Api::UsersController, type: :request do
  let(:user) { FactoryBot.create :user }

  context 'When fetching a user' do
    before do
      login_with_api(user)
      get "/api/users/#{user.id}", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the user' do
      expect(json['data']).to have_id(user.id.to_s)
      expect(json['data']).to have_type('users')
    end
  end

  context 'When a user is missing' do
    before do
      login_with_api(user)
      get '/api/users/blank', headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns not found' do
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'When the Authorization header is missing' do
    before do
      get "/api/users/#{user.id}"
    end

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
