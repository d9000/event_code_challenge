require 'rails_helper'
RSpec.describe API::V1::EventsController, type: :request do
    let!(:user) { create(:user) }
    let!(:events) { create_list(:event, 10, { creator: user }) }
    let(:user_id) { user.id }
    let(:id) { events.first.id }
    describe 'GET /api/v1/users' do
        before { get '/api/v1/users' }
    
        it 'returns users' do
          expect(json).not_to be_empty
        end
    
        it 'returns status code ok' do
          expect(response).to have_http_status(200)
        end
    end
    describe 'GET /api/v1/users/:id' do
        before { get "/api/v1/users/#{user_id}" }
    
        context 'when the user exists' do
          it 'returns the user' do
            expect(json).not_to be_empty
            expect(json['id']).to eq(user_id)
          end
    
          it 'returns status ok' do
            expect(response).to have_http_status(200)
          end
        end
    
        context 'when the user does not exist' do
          let(:user_id) { 123123 }
    
          it 'empty JSON' do
            expect(json['message']).to include("Couldn't find User")
          end
         
        end
      end
      describe 'POST /api/v1/users' do
        # valid payload
        let(:valid_attributes) { { username: 'john_doe'  } }
    
        context 'when the request is valid' do
          before { post '/api/v1/users', params: valid_attributes }
    
          it 'creates an user' do
            json = JSON.parse(response.body)
            expect(json).not_to be_empty
          end
    
          it 'returns status code 201' do
            expect(response).to have_http_status(201)
          end
        end
    
        context 'when the request is invalid' do
          before { post '/api/v1/users' }
    
          it 'returns status code 422' do
            expect(response).to have_http_status(422)
          end
    
          it 'returns a validation failure message' do
            expect(response.body)
              .to include("Invalid")
          end
        end
      end
      describe 'GET /api/v1/users/:user_id/events' do
        before { get "/api/v1/users/#{user_id}/events" }
    
        context 'when user exists' do
          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end
    
          it 'returns all user events' do
            expect(json.size).to eq(10)
          end
        end
    
        context 'when user does not exist' do
          let(:user_id) { 0 }
    
          it 'returns status code 404' do
            expect(response).to have_http_status(404)
          end
    
          it 'returns a not found message' do
            expect(json['message']).to include("Couldn't find")
          end
        end
      end
      describe 'POST /api/v1/users/:user_id/events' do
        let(:valid_attributes) { { start: Date.today, duration: 20, timezone: 'CET', user_id: user_id  } }
       
        context 'when request attributes are valid' do
          before { post "/api/v1/users/#{user_id}/events", params: valid_attributes }
    
          it 'returns status ok' do
            expect(response).to have_http_status(200)
          end
        end
    
        context 'when an invalid request' do
          before { post "/api/v1/users/#{user_id}/events", params: {} }
    
          it 'returns status code 422' do
            expect(response).to have_http_status(422)
          end
    
          it 'returns a failure message' do
            expect(response.body).to include('errors')
          end
        end
      end

end