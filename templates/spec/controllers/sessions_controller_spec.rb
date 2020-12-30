# frozen_string_literal: true

require 'rails_helper'

describe SessionsController, type: :request do
  let(:user) { FactoryBot.create :user }
  let(:login_url) { '/api/login' }
  let(:logout_url) { '/api/logout' }

  context 'When logging in' do
    before do
      login_with_api(user)
    end

    it 'returns a token' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns http status ok' do
      expect(response).to have_http_status(:ok)
    end
  end

  context 'When password is missing' do
    before do
      post login_url, params: {
        user: {
          email: user.email,
          password: nil
        }
      }
    end

    it 'returns http status unauthorized' do
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'When logging out' do
    it 'returns no content' do
      delete logout_url

      expect(response).to have_http_status(:no_content)
    end
  end
end
