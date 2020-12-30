# frozen_string_literal: true

require 'rails_helper'

describe RegistrationsController, type: :request do
  let(:user) { FactoryBot.build :user }
  let(:existing_user) { FactoryBot.create :user }
  let(:signup_url) { '/api/signup' }

  context 'When creating a new user' do
    before do
      post signup_url, params: {
        user: {
          email: user.email,
          password: user.password
        }
      }
    end

    it 'returns http status ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns a token' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns the user email' do
      expect(json['data']).to have_attribute(:email).with_value(user.email)
    end
  end

  context 'When an email already exists' do
    before do
      post signup_url, params: {
        user: {
          email: existing_user.email,
          password: existing_user.password
        }
      }
    end

    it 'returns 400' do
      expect(response).to have_http_status(:bad_request)
    end
  end
end
