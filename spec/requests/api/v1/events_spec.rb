require 'rails_helper'
RSpec.describe API::V1::EventsController, type: :request do
  let!(:user) { create(:user) }
  let!(:event) { { creator: user } }
  let!(:events) { create_list(:event, 10)}
  let(:event_id) { events.first.id }
  describe 'GET /api/v1/events' do
    before { get '/api/v1/events' }

    it 'returns events' do
      expect(json).not_to be_empty
    end

    it 'returns status code ok' do
      expect(response).to have_http_status(200)
    end
  end
  describe 'GET /api/v1/events/:id' do
    before { get "/api/v1/events/#{event_id}" }

    context 'when the event exists' do
      it 'returns the event' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(event_id)
      end

      it 'returns status ok' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the event does not exist' do
      let(:event_id) { 123123 }

      it 'JSON with' do
        expect(json['message']).to include("Couldn't find Event")
      end
     
    end
  end
  describe 'POST /api/v1/events' do
    # valid payload
    let(:valid_attributes) { { start: Date.today, duration: 20, timezone: 'CET', user_id: user.id  } }

    context 'when the request is valid' do
      before { post '/api/v1/events', params: valid_attributes }

      it 'creates an event' do
        json = JSON.parse(response.body)
        expect(json).not_to be_empty
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/events', params: { start: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to include("Invalid")
      end
    end
  end
  describe 'PUT /api/v1/events/:id' do
    let(:valid_attributes) { { start: Date.today, duration: 20, timezone: 'CET', user_id: user.id  } }
    
    context 'when the record exists' do
      before { put "/api/v1/events/#{event_id}", params: valid_attributes }

      it 'updates the record' do
        expect(json['id']).to eq(event_id)
      end

      it 'returns status code ok' do
        expect(response).to have_http_status(200)
      end
    end
  end
  describe 'DELETE /api/v1/events/:id' do
    before { delete "/api/v1/events/#{event_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
  describe 'PUT /api/v1/events/:id/publish' do
    let(:publish_attributes) { { start: Date.today, duration: 20, timezone: 'CET', user_id: user.id, name: 'Foo', description: 'Foofoo', location: 'OficeFoo' } }
    context 'when all attributes are complete' do
      before { put "/api/v1/events/#{event_id}/publish" , params: publish_attributes}
      it 'returns event published' do
        expect(json['state']).to include('published')
      end
    end
    
  end
  
   
end
